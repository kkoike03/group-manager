# 食品の購入先登録機能 実装ログ

## 背景，基本方針

模擬店(食品販売)は購入先登録が必要．
保健所へ提出する書類には購入先に関する情報(名前，営業時間等)が必要．

Shopモデルに店舗情報を登録し，あとから実装する購入物品でこれと関連付ける．
店舗は予め登録するが，ユーザから追加する場合を考慮してCURDも実装する．

## shop CURD

```
bundle exec rails g scaffold shop name:string tel:string time_weekdays:string time_sat:string time_sun:string time_holidays:string

      invoke  active_record
      create    db/migrate/20150627152409_create_shops.rb
      create    app/models/shop.rb
      invoke  resource_route
       route    resources :shops
      invoke  scaffold_controller
      create    app/controllers/shops_controller.rb
      invoke    erb
      create      app/views/shops
      create      app/views/shops/index.html.erb
      create      app/views/shops/edit.html.erb
      create      app/views/shops/show.html.erb
      create      app/views/shops/new.html.erb
      create      app/views/shops/_form.html.erb
      invoke    helper
      create      app/helpers/shops_helper.rb
      invoke    jbuilder
      create      app/views/shops/index.json.jbuilder
      create      app/views/shops/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/shops.coffee
      invoke    scss
      create      app/assets/stylesheets/shops.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.scss
```

`db/migrate/20150627152409_create_shops.rb`で`null: false`を追加

```
rake db:migrate

== 20150627152409 CreateShops: migrating ======================================
-- create_table(:shops)
   -> 0.0074s
== 20150627152409 CreateShops: migrated (0.0075s) =============================
``` 

## bootstrap 適用

```
bundle exec rails g bootstrap:themed Shops

    conflict  app/views/shops/index.html.erb
Overwrite /Volumes/HD2/Dropbox/nfes15/group_manager/app/views/shops/index.html.erb? (enter "h" for help) [Ynaqdh] a
       force  app/views/shops/index.html.erb
    conflict  app/views/shops/new.html.erb
       force  app/views/shops/new.html.erb
    conflict  app/views/shops/edit.html.erb
       force  app/views/shops/edit.html.erb
    conflict  app/views/shops/_form.html.erb
       force  app/views/shops/_form.html.erb
    conflict  app/views/shops/show.html.erb
       force  app/views/shops/show.html.erb
```

## ActiveAdminの管理対象に追加

```
bundle exec rails generate active_admin:resource Shop
```

permit_paramsのみ設定

## Shopにカナ, closedを追加

```
bundle exec rails g migration AddColumnToShop kana:string closed:string
      invoke  active_record
      create    db/migrate/20150628131626_add_column_to_shop.rb

rake db:migrate
== 20150628131626 AddColumnToShop: migrating ==================================
-- add_column(:shops, :kana, :string)
   -> 0.0010s
-- add_column(:shops, :closed, :string)
   -> 0.0005s
== 20150628131626 AddColumnToShop: migrated (0.0017s) =========================
```

`closed`には定休日の曜日を数字指定で入れる．
曜日は日曜日が0で土曜日が6.
日曜日が定休日のときには'0', 土日が定休日なら['0', '6']

## Shopモデルにバリデーション追加

## Shop初期データ 投入

`db/fixtures/shop.rb`を追加して

```
rake db:seed_fu
```

## 権限の追加

ユーザに店舗を新規に登録させる必要がない気がしてきた．
管理者にのみ編集権限を与えることにする．(ただし削除は禁止

`app/controllers/shops_controller.rb`に`load_and_authorize_resource`を追加
`app/models/ability.rb`のmanagerに`cannot [:destroy], Shop`を追加

---

## 需要があったためユーザによるCURDを実装する．

ユーザの削除，更新を禁止とする．
閲覧・追加のみ許可

### views/indexの修正

Deleteボタン削除，辞書追加

### views/showの修正

Deleteボタン削除，辞書追加．
休日表示のため`closed_days`メソッドを追加

### views/_formの修正

不足しているカラムを追加．
permit_paramsに追加
バリデーションを追加．
辞書追加

### 管理用設定の変更

permit_paramsに追加

## 仕入先一覧のリンクを追加

```
--- a/app/views/welcome/index.html.erb
+++ b/app/views/welcome/index.html.erb
@@ -107,5 +107,8 @@
     <%= link_to t('提供品の一覧'),
             index_noncooking_purchase_lists_path,
             :class => 'btn btn-default' %>
+    <%= link_to t('選択可能な仕入先の一覧'),
+            shops_path,
+            :class => 'btn btn-default' %>
   </div>
 </div>
```

## 警告の追加

パーシャルで`warning_xxx`を追加．
登録ボタンに確認ダイアログを追加

## views/purchase_lists/_form に仕入先登録のリンクを追加

## 権限を変更

```
@@ -45,7 +45,7 @@ class Ability
-      cannot [:destroy], Shop # Shopは削除禁止
+      cannot [:destroy], Shop, :id => [*(1..23)]  # Shopは1-23のデフォルトの削除禁止
```

## 調理開始時間の追加

```
bundle exec rails g migration AddColumnStartToFoodProduct start:string
      invoke  active_record
      create    db/migrate/20150703190414_add_column_start_to_food_product.rb

rake db:migrate

== 20150703190414 AddColumnStartToFoodProduct: migrating ======================
-- add_column(:food_products, :start, :string)
   -> 0.0010s
== 20150703190414 AddColumnStartToFoodProduct: migrated (0.0011s) =============
```

ActiveAdminで`start`カラムが編集可能なように`permit_params`を追加，表示へカラムを追加

```
@@ -1,6 +1,6 @@
 ActiveAdmin.register FoodProduct do

-  permit_params :group_id, :name, :num, :is_cooking
+  permit_params :group_id, :name, :num, :is_cooking, :start

   index do
     selectable_column
@@ -9,6 +9,7 @@ ActiveAdmin.register FoodProduct do
     column :name
     column :num
     column :is_cooking
+    column :start
     actions
   end

@@ -20,6 +21,7 @@ ActiveAdmin.register FoodProduct do
     column :name
     column :num
     column :is_cooking
+    column :start
   end
```

バリデーションを追加

```
class FoodProduct < ActiveRecord::Base
   belongs_to :group

+  validates_presence_of :start, if: :is_cooking # self.is_cooking == true でstartが必須

   validates_numericality_of :group_id, :num
```

フォームから`start`を編集可能にする

```
app/views/food_products/_form.html.erb
@@ -29,6 +29,9 @@
     </p>
   </div>

+  <%= f.input :start, hint: t(".hint_start") %>
+  <%= error_span(@food_product[:num]) %>
+
   <%= f.button :submit, :class => 'btn-primary' %>
```

```
class FoodProductsController < ApplicationController

     # Never trust parameters from the scary internet, only allow the white list through.
     def food_product_params
-      params.require(:food_product).permit(:group_id, :name, :num, :is_cooking)
+      params.require(:food_product).permit(:group_id, :name, :num, :is_cooking, :start)
     end
```
