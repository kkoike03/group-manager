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
