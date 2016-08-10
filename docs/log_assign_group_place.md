### 「食販, 物販, 展示, その他」の団体が利用する場所を決定する機能

**仕様** : [場所の確定機能を追加](https://github.com/NUTFes/group-manager/issues/41)を参照

---

#### 販売, 展示, その他団体が使用する場所の確定用modelを生成

```
# model生成
$ bundle exec rails g model AssignGroupPlace place_order:references place:references
```

生成されたmigrateファイルを修正し,  
null:false制約を追加

```diff
class CreateAssignGroupPlaces < ActiveRecord::Migration
  def change
    create_table :assign_group_places do |t|
+     t.references :place_order, index: true, foreign_key: true, null:false
+     t.references :place, index: true, foreign_key: true, null:false

      t.timestamps null: false
    end
  end
end
```

### 管理画面を追加

```
# 管理画面の生成
$ bundle exec rails g active_admin:resource AssignGroupPlace
```


### 既存のPlaceOrderに合わせ, 初期レコードを生成するスクリプトを追加

団体に場所を割り当てるためにレコードを初期化する.  
販売, 展示, その他団体は, 1団体につき1つの場所が割り当てられる.  
バッチ処理で, 全ての販売, 展示, その他団体のレコードを初期化する. 

```sh
# rakeタスクの生成
$ bundle exec rails g task assign_group_place
```

```ruby
# lib/tasks/assign_group_place.rake
namespace :assign_group_place do
  task initialize_records: :environment do
    Place.find_or_create_by(id:0, name_ja:"未入力")
    PlaceOrder.all.each do |ord|
      AssignGroupPlace.find_or_create_by(place_order_id: ord.id) do |agp|
        agp.place_id = 0
      end
    end
  end
end
```


### 管理画面のindex, editページを編集

active adminでは, ``column :place_order``を呼び出す際にPlaceOrderモデルの``to_s``が自動で呼ばれる.  
PlaceOrderモデルに``to_s``メソッドを定義することで名前を表示する.  

```diff
# app/models/place_order.rb

+  def to_s
+    self.group.name
+  end
```

今回は, 希望申請を編集画面に表示する必要があった.  
そのため, formでレコードを参照し, 表示している. 

```diff
# app/admin/assign_group_place.rb

ActiveAdmin.register AssignGroupPlace do

+  permit_params :place_id

-  # See permitted parameters documentation:
-  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
-  #
-  # permit_params :list, :of, :attributes, :on, :model
-  #
-  # or
-  #
-  # permit_params do
-  #   permitted = [:permitted, :attributes]
-  #   permitted << :other if resource.something?
-  #   permitted
-  # end
+  index do
+    selectable_column
+    id_column
+    column :place_order   #PlaceOrder::to_sで名前引き
+    column :place
+    actions
+  end

+  form do |f|
+    order  = f.object.place_order
+    places = Place.usable_all_places   #Placeモデルにクエリを定義
+    message= "未回答"
+
+    panel "申請情報" do
+      li "グループ: #{order.group}"
+      li "第1希望 : #{order.first ?  places.find(order.first)  : message}"
+      li "第2希望 : #{order.second ? places.find(order.second) : message}"
+      li "第3希望 : #{order.third ?  places.find(order.third)  : message}"
+    end
+
+    f.inputs '団体の場所確定' do
+      input :place, :as => :select, :collection => places
+    end
+    f.actions
+  end
```

active adminのform内で呼んでいる``Place.usable_all_places``の定義  
利用が許可されている全ての場所を読み込んでいる.  
```diff
# app/models/place.rb

     self.search_enable_place(group_category_id)
   end
+
+  def self.usable_all_places
+    Place.joins(:place_allow_lists) \
+      .uniq.where(place_allow_lists:{enable:true}).order(:id)
+  end
```


### 管理画面の日本語化
```diff
# config/locales/01_model/ja.yml

       group_project_name: 企画名
       stage: ステージ
       group_manager_common_option: アプリ共通設定
+      assign_group_place: 使用場所
     attributes:
         group:
           name: 運営団体の名称
@@ -148,3 +149,6 @@ ja:
         group_manager_common_option:
           cooking_start_time: 調理開始時間
           date_of_stool_test: 検便実施日
+        assign_group_place:
+          place_order: 団体名
+          place: 使用場所

```

### validateとcancancanの設定

validateの設定を行う. 
値の存在checkと[場所申請ID&場所ID]でユニークcheckを追加

```diff
# app/models/assign_group_place.rb

 class AssignGroupPlace < ActiveRecord::Base
   belongs_to :place_order
   belongs_to :place
+  validates_presence_of :place_order_id, :place_id
+  validates :place_order_id, uniqueness: {scope: [:place_id] }
 end
```

cancancanの設定
管理者が削除を行えないように変更

```diff
# app/models/ability.rb

cannot [:create, :destroy], GroupManagerCommonOption # 作成・削除不可
cannot [:create, :destroy], RentalItemAllowList # 作成・削除不可
+ cannot [:destroy], AssignGroupPlace # 削除不可

```


### グループ生成時に初期レコードを生成する機能を追加

新しい団体が生成されたタイミングで,  
団体の使用場所を入力するためのレコードを初期化する.  

```diff
# app/controllers/groups_controller.rb

@group.init_place_order # 実施場所申請用のレコードを生成
@group.init_stage_common_option # ステージ企画の共通項目のレコードを生成
+ @group.init_assign_place_order # 使用場所用のレコードを生成
```

生成のロジックは以下.  
```diff
# app/models/group.rb

+  # 使用場所用のレコードを生成
+  def init_assign_place_order
+    return unless order = PlaceOrder.find_by(group_id: id)
+    Place.find_or_create_by(id: 0, name_ja:"未入力")
+    AssignGroupPlace.find_or_create_by(place_order_id: order.id) do |agp|
+      agp.place_id = 0
+    end
+  end
```
