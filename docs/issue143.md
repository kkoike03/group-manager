# issue 143 実装ログ

[貸出物品割当入力機能](https://github.com/NUTFes/group-manager/issues/143)  

作業中は, 必ず細かくgit commitしておくこと.  
特に, ``rails g`` や``rake``コマンドの後は大きな変更が加えられるので,   
その時点の状態を保存しておく.   


## CRUDの実装 (MVCの生成)

```sh
$ bundle exec rails g scaffold AssignRentalItem rental_order:references rentable_item:references num:integer
Running via Spring preloader in process 25078
      invoke  active_record
      create    db/migrate/20160810072112_create_assign_rental_items.rb
      create    app/models/assign_rental_item.rb
      invoke  resource_route
       route    resources :assign_rental_items
      invoke  scaffold_controller
      create    app/controllers/assign_rental_items_controller.rb
      invoke    erb
      create      app/views/assign_rental_items
      create      app/views/assign_rental_items/index.html.erb
      create      app/views/assign_rental_items/edit.html.erb
      create      app/views/assign_rental_items/show.html.erb
      create      app/views/assign_rental_items/new.html.erb
      create      app/views/assign_rental_items/_form.html.erb
      invoke    helper
      create      app/helpers/assign_rental_items_helper.rb
      invoke    jbuilder
      create      app/views/assign_rental_items/index.json.jbuilder
      create      app/views/assign_rental_items/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/assign_rental_items.coffee
      invoke    scss
      create      app/assets/stylesheets/assign_rental_items.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.scss
```


## マイグレーションファイルの変更 + 実行

テーブルの各カラム`rental_order`, `rentable_item`, `num`は必須．
なので，DBレベルで制約を追加する．

```diff
--- a/db/migrate/20160810072112_create_assign_rental_items.rb
+++ b/db/migrate/20160810072112_create_assign_rental_items.rb
@@ -1,8 +1,8 @@
 class CreateAssignRentalItems < ActiveRecord::Migration
   def change
     create_table :assign_rental_items do |t|
-      t.references :rental_order, index: true, foreign_key: true
-      t.references :rentable_item, index: true, foreign_key: true
+      t.references :rental_order, index: true, foreign_key: true, null: false
+      t.references :rentable_item, index: true, foreign_key: true, null: false
       t.integer :num

       t.timestamps null: false
```

マイグレーション実行

```sh
$ rake db:migrate
== 20160810072112 CreateAssignRentalItems: migrating ==========================
-- create_table(:assign_rental_items)
   -> 0.0411s
== 20160810072112 CreateAssignRentalItems: migrated (0.0411s) =================
```


## 既存のモデルへRailsレベルで関連付け

マイグレーションにより，DBレベルで
AssignRentalItemテーブルとRentalOrder, RentableItemは関連付けされている．

この関連付けは`../app/models/assign_rental_item.rb`には書かれているが，
`../app/models/rental_order.rb`, `../app/models/rental_item.rb`には
入っていない．
ので追加する．

```diff
 class RentalOrder < ActiveRecord::Base
   belongs_to :group
   belongs_to :rental_item
+  has_many :assign_rental_item

   validates :group_id, :rental_item_id, :num, presence: true
```

```diff
 class RentableItem < ActiveRecord::Base
   belongs_to :stocker_item
   belongs_to :stocker_place
+  has_many :assign_rental_item

   validates :stocker_item_id, :stocker_place_id, :max_num, presence: true
```


## バリデーションを追加

モデルにnull値を防止するバリデーションを追加する

```diff
 class AssignRentalItem < ActiveRecord::Base
   belongs_to :rental_order
   belongs_to :rentable_item
+
+  validates_presence_of :rental_order_id, :rentable_item_id, :num
+  validates :num, numericality: :only_integer
+  validates :rental_order_id, uniqueness: {scope: [:rentable_item_id] }
 end
```


## bootstrapを適用

```sh
$ bundle exec rails g bootstrap:themed AssignRentalItems
Running via Spring preloader in process 39834
    conflict  app/views/assign_rental_items/index.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/assign_rental_items/index.html.erb? (enter "h" for help) [Ynaqdh] a
       force  app/views/assign_rental_items/index.html.erb
    conflict  app/views/assign_rental_items/new.html.erb
       force  app/views/assign_rental_items/new.html.erb
    conflict  app/views/assign_rental_items/edit.html.erb
       force  app/views/assign_rental_items/edit.html.erb
    conflict  app/views/assign_rental_items/_form.html.erb
       force  app/views/assign_rental_items/_form.html.erb
    conflict  app/views/assign_rental_items/show.html.erb
       force  app/views/assign_rental_items/show.html.erb
```

## _form 修正

```diff
+++ b/app/views/assign_rental_items/_form.html.erb
@@ -1,7 +1,7 @@
-<%= simple_form_for @assign_rental_item, :html => { :class => 'form-horizontal' } do |f| %>
-  <%= f.input :rental_order_id %>
+<%= simple_form_for @assign_rental_item, wrapper: "horizontal_form", :html => { :class => 'form-horizontal' } do |f| %>
+  <%= f.association :rental_order %>
   <%= error_span(@assign_rental_item[:rental_order_id]) %>
-  <%= f.input :rentable_item_id %>
+  <%= f.association :rentable_item %>
   <%= error_span(@assign_rental_item[:rentable_item_id]) %>
   <%= f.input :num %>
   <%= error_span(@assign_rental_item[:num]) %>
```

`id`ではなく，associationを使う．
associationは各モデルの`to_s`メソッドを表示に使うので，
`RentalOrder`と`RentableItem`に`to_s`を実装．

```diff
@@ -9,4 +9,8 @@ class RentalOrder < ActiveRecord::Base
   }
   validates :group_id, :uniqueness => {:scope => :rental_item_id }

+  def to_s
+    self.group.name + ' (' + self.rental_item.name_ja + \
+    ', 数: ' + self.num.to_s + ')'
+  end
 end
```

```diff
@@ -11,4 +11,10 @@ class RentableItem < ActiveRecord::Base
   # validate 貸し出し可能数は在庫数以下
   validates_with RentableItemValidator, on: :create
   validates_with RentableItemValidator, on: :update
+
+  def to_s
+    self.stocker_item.rental_item.name_ja + \
+    ' (' + self.stocker_item.stocker_place.name + \
+    ', 数:' + self.max_num.to_s + ')'
+  end
 end
```


## 管理画面に追加

```sh
$ bundle exec rails generate active_admin:resource AssignRentalItem
Running via Spring preloader in process 42730
      create  app/admin/assign_rental_item.rb
```

管理画面のインデックスページを見やすくする．

```diff
+  index do
+    selectable_column
+    id_column
+    column :rental_order
+    column :rentable_item
+    actions
+  end
```

管理画面から編集・作成をしたいので

```diff
@@ -14,6 +14,8 @@ ActiveAdmin.register AssignRentalItem do
   #   permitted
   # end

+  permit_params :rental_order_id, :rentable_item_id, :num
+
   index do
     selectable_column
```

## バリデータ追加

貸出希望と貸出可能物品が同一のときのみ許可するバリデータを追加．


## 割当数0のレコードを生成する

タスクを作成．

```python
$ bundle exec rails g task assign_rental_item
Running via Spring preloader in process 52549
      create  lib/tasks/assign_rental_item.rake
```

`lib/tasks/assign_rental_item.rake`を編集．実行は

```sh
$ rake assign_rental_item:init_this_year
```

## 割当ページの変更

1物品に関する割当一覧を
`assign_rental_items/item_list?item_id=物品ID`
で出力する．


コントローラメソッドに`item_list`を追加．

```diff
@@ -7,6 +7,18 @@ class AssignRentalItemsController < ApplicationController
     @assign_rental_items = AssignRentalItem.all
   end

+  # GET /assign_rental_items?item_id=XXX
+  def item_list
+    # get パラメータからRentalItemレコードを取得
+    rental_item = RentalItem.find(params[:item_id])
+    # 今年度のrental_itemに関連するorderとrentable_itemを取得
+    this_year = FesYear.this_year()
+    @orders = RentalOrder.year(this_year).where(rental_item_id: rental_item)
+    @rentables = RentableItem.year(this_year)
+      .joins(stocker_item: :rental_item)
+      .where(rental_items: {id: rental_item})
+  end
+
   # GET /assign_rental_items/1
   # GET /assign_rental_items/1.json
```

このメソッドでrenderされるviewファイル
`app/views/assign_rental_items/item_list.html.erb`を作成．

ルーティングを設定

```diff
 Rails.application.routes.draw do
-  resources :assign_rental_items
+  resources :assign_rental_items do
+    # 標準の7つ以外を追加する
+    collection do
+      get 'item_list'
+    end
+  end
+
   get 'health_check_pages/cooking'
```


## インデックスページの変更

インデックスページは各物品の割当ページヘのリンクを生成する．
コントローラで全物品を取得し，viewへ渡す

```diff
@@ -4,7 +4,7 @@ class AssignRentalItemsController < ApplicationController
   # GET /assign_rental_items
   # GET /assign_rental_items.json
   def index
-    @assign_rental_items = AssignRentalItem.all
+    @items = RentalItem.all
   end

   # GET /assign_rental_items?item_id=XXX
```

viewページを変更

```diff
+++ b/app/views/assign_rental_items/index.html.erb
@@ -5,36 +5,22 @@
 <table class="table table-striped">
   <thead>
     <tr>
-      <th><%= model_class.human_attribute_name(:id) %></th>
-      <th><%= model_class.human_attribute_name(:rental_order_id) %></th>
-      <th><%= model_class.human_attribute_name(:rentable_item_id) %></th>
-      <th><%= model_class.human_attribute_name(:num) %></th>
-      <th><%= model_class.human_attribute_name(:created_at) %></th>
-      <th><%=t '.actions', :default => t("helpers.actions") %></th>
+      <th><%= RentalItem.human_attribute_name(:name_ja) %></th>
+      <th></th>
     </tr>
   </thead>

@@ -5,36 +5,22 @@
 <table class="table table-striped">
   <thead>
     <tr>
-      <th><%= model_class.human_attribute_name(:id) %></th>
-      <th><%= model_class.human_attribute_name(:rental_order_id) %></th>
-      <th><%= model_class.human_attribute_name(:rentable_item_id) %></th>
-      <th><%= model_class.human_attribute_name(:num) %></th>
-      <th><%= model_class.human_attribute_name(:created_at) %></th>
-      <th><%=t '.actions', :default => t("helpers.actions") %></th>
+      <th><%= RentalItem.human_attribute_name(:name_ja) %></th>
+      <th></th>
     </tr>
   </thead>
   <tbody>
-    <% @assign_rental_items.each do |assign_rental_item| %>
+    <% @items.each do |item| %>
       <tr>
-        <td><%= link_to assign_rental_item.id, assign_rental_item_path(assign_rental_item) %></td>
-        <td><%= assign_rental_item.rental_order_id %></td>
-        <td><%= assign_rental_item.rentable_item_id %></td>
-        <td><%= assign_rental_item.num %></td>
-        <td><%=l assign_rental_item.created_at %></td>
+        <td><%= item.name_ja %></td>
         <td>
           <%= link_to t('.edit', :default => t("helpers.links.edit")),
-                      edit_assign_rental_item_path(assign_rental_item), :class => 'btn btn-default btn-xs' %>
-          <%= link_to t('.destroy', :default => t("helpers.links.destroy")),
-                      assign_rental_item_path(assign_rental_item),
-                      :method => :delete,
-                      :data => { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => 'Are you sure?')) },
-                      :class => 'btn btn-xs btn-danger' %>
+            controller: 'assign_rental_items',
+            action: 'item_list',
+            item_id: item.id,
+            :class => 'btn btn-default btn-xs' %>
         </td>
       </tr>
     <% end %>
   </tbody>
 </table>
-
-<%= link_to t('.new', :default => t("helpers.links.new")),
-            new_assign_rental_item_path,
-            :class => 'btn btn-primary' %>
```

## _form修正

希望レコードとrentable_itemレコードを変更不可へ

パラメータはhiddenで渡す．
ただし表示はする．

```diff
@@ -1,8 +1,10 @@
 <%= simple_form_for @assign_rental_item, wrapper: "horizontal_form", :html => { :class => 'form-horizontal' } do |f| %>
-  <%= f.association :rental_order %>
-  <%= error_span(@assign_rental_item[:rental_order_id]) %>
-  <%= f.association :rentable_item %>
-  <%= error_span(@assign_rental_item[:rentable_item_id]) %>
+  <%= f.hidden_field :rental_order_id %>
+  <%= f.hidden_field :rentable_item_id %>
+
+  '希望情報: '<%= @assign_rental_item.rental_order.to_s %> <br>
+  '割当対象: '<%= @assign_rental_item.rentable_item.to_s %>
+
   <%= f.input :num %>
```

## リンク修正

_form, showでcancel, backのリンク先を各物品の一覧へ変更
デストロイボタンを削除

```diff
diff --git a/app/views/assign_rental_items/_form.html.erb b/app/views/assign_rental_items/_form.html.erb
index 952be84..7641650 100644
--- a/app/views/assign_rental_items/_form.html.erb
+++ b/app/views/assign_rental_items/_form.html.erb
@@ -10,5 +10,9 @@

   <%= f.button :submit, :class => 'btn-primary' %>
   <%= link_to t('.cancel', :default => t("helpers.links.cancel")),
-                assign_rental_items_path, :class => 'btn btn-default' %>
+    controller: 'assign_rental_items',
+    action: 'item_list',
+    item_id: @assign_rental_item.rental_order.rental_item_id,
+    :class => 'btn btn-default btn-xs' %>
+
 <% end %>
diff --git a/app/views/assign_rental_items/show.html.erb b/app/views/assign_rental_items/show.html.erb
index d9f3475..f26ffd6 100644
--- a/app/views/assign_rental_items/show.html.erb
+++ b/app/views/assign_rental_items/show.html.erb
@@ -13,11 +13,10 @@
 </dl>

 <%= link_to t('.back', :default => t("helpers.links.back")),
-              assign_rental_items_path, :class => 'btn btn-default'  %>
+  controller: 'assign_rental_items',
+  action: 'item_list',
+  item_id: @assign_rental_item.rental_order.rental_item_id,
+  :class => 'btn btn-default btn-xs' %>
+
 <%= link_to t('.edit', :default => t("helpers.links.edit")),
               edit_assign_rental_item_path(@assign_rental_item), :class => 'btn btn-default' %>
-<%= link_to t('.destroy', :default => t("helpers.links.destroy")),
-              assign_rental_item_path(@assign_rental_item),
-              :method => 'delete',
```

## 権限設定

管理者は削除不可．

`Ability`モデルに管理者用の権限を追加

```diff
diff --git a/app/models/ability.rb b/app/models/ability.rb
@@ -56,6 +56,7 @@ class Ability
       cannot [:create, :destroy], Stage # 作成・削除不可
       cannot [:create, :destroy], GroupManagerCommonOption # 作成・削除不可
       cannot [:create, :destroy], RentalItemAllowList # 作成・削除不可
+      cannot [:destroy], AssignRentalItem # 削除不可, 0で対応
     end
     if user.role_id == 3 then # for user (デフォルトのrole)
       can :manage, :welcome
```

cancancanの設定をコントローラから反映

```diff
diff --git a/app/controllers/assign_rental_items_controller.rb b/app/controllers/assign_rental_items_controller.rb
index 6baad7c..403d397 100644
--- a/app/controllers/assign_rental_items_controller.rb
+++ b/app/controllers/assign_rental_items_controller.rb
@@ -1,5 +1,6 @@
 class AssignRentalItemsController < ApplicationController
   before_action :set_assign_rental_item, only: [:show, :edit, :update, :destroy]
+  load_and_authorize_resource  # for cancancan

   # GET /assign_rental_items
```

## 数量に関するバリデータを追加
