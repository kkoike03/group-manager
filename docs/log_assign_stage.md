## ステージ団体の使用場所を入力する機能

仕様 : [場所の確定機能を追加](https://github.com/NUTFes/group-manager/issues/41)を参照

---

### ステージ決定用のmodelを生成

```sh
# model生成
$ bundle exec rails g model AssignStage stage_order:references stage:references time_point_start:string time_point_end:string
# マイグレート
$ bundle exec rake db:migrate
```

### 管理画面を生成

```sh
# 管理画面の生成
$ bundle exec rails g active_admin:resource AssignStage
```

### 初期レコードを生成するスクリプトを追加

ステージの申請は, 1団体につき, 1日目/2日目と晴天/雨天の2通り×2通りの4通りが存在する.  
そのため, 1団体につき4つのレコードを生成する. 


```ruby
# lib/tasks/assign_stage.rake

namespace :assign_stage do
  task initialize_records: :environment do
    empty = "未入力"
    Stage.find_or_create_by(id:0, name_ja:empty)
    StageOrder.all.each do |ord|
      AssignStage.find_or_create_by(stage_order_id: ord.id) do |as|
        as.stage_id = 0
        as.time_point_start = empty
        as.time_point_end   = empty
      end
    end
  end

end
```

rakeタスクの実行
```sh
# 初期化レコードの生成
$ bundle exec rake assign_stage:initialize_records
```

### 管理画面を編集(index, edit)

index : 希望申請と決定項目を同時に表示する. 
edit  : 希望申請を表示し, [使用場所], [開始時刻], [終了時刻]を入力する

```diff
# app/admin/assign_stage.rb


 ActiveAdmin.register AssignStage do

+  permit_params :stage_id, :time_point_s
tart, :time_point_end

-  # See permitted parameters documentati
on:
-  # https://github.com/activeadmin/activ
eadmin/blob/master/docs/2-resource-custom
ization.md#setting-up-strong-parameters
-  #
-  # permit_params :list, :of, :attribute
s, :on, :model
-  #
-  # or
-  #
-  # permit_params do
-  #   permitted = [:permitted, :attribut
es]
-  #   permitted << :other if resource.so
mething?
-  #   permitted
-  # end
+  index do
+    selectable_column
+    id_column
+    column :stage_order do |as|
+      as.stage_order.group
+    end
+    column :fes_date do |as|
+      FesDate.find(as.stage_order.fes_da te_id)
+    end

+    column :is_sunny do |as|
+      as.stage_order.is_sunny ? "晴天時" : "雨天時"
+    end
+    column :order_time_start do |as|
+      as.stage_order.time_point_start
+    end

+    column :order_time_end do |as|
+      as.stage_order.time_point_end
+    end
+
+    column :order_time_interval do |as|
+      as.stage_order.time_interval
+    end
+
+    column :stage
+    column :time_point_start
+    column :time_point_end
+    actions
+  end
+
+  form do |f|
+    set_time_point
+    order  = f.object.stage_order
+    stages = Stage.all
+    message= "未回答"
+
+    panel "申請情報" do
+      li "グループ: #{order.group}"
+      li "希望場所1 : #{order.stage_first ?  stages.find(order.stage_first)  : message}"
+      li "希望場所2 : #{order.stage_second ? stages.find(order.stage_second) : message}"
+      li "希望開始時間 : #{order.time_point_start ? order.time_point_start : message}"
+      li "希望終了時間 : #{order.time_point_end ? order.time_point_end : message}"
+      li "希望時間幅 : #{order.time_interval ? order.time_interval : message}"
+    end
+
+    f.inputs '団体のステージ場所&時間決 定' do
+      input :stage, :as => :select, :collection => stages
+      input :time_point_start, :as => :select, :collection => @time_point
+      input :time_point_end, :as => :select, :collection => @time_point
+    end
+    f.actions
+  end
+end
+
+def set_time_point
+  @time_point = [["", ""]]
+  (8..21).each do |h|
+    %w(00 15 30 45).each do |m|
+      @time_point.push ["#{"%02d" % h}:#{m}","#{"%02d" % h}:#{m}"]
+    end
+  end
 end
```

### validateの追加

値の存在checkと時間に関する制約を追加
基本的には, ``app/models/stage_order.rb``を参考にした.  


```diff
# app/models/assign_stage.rb


class AssignStage < ActiveRecord::Base
  belongs_to :stage_order
  belongs_to :stage
+
+ validates_presence_of :stage_order_id, :stage_id
+ validate :time_is_only_selected, :start_to_end
+
+ def time_is_only_selected
+   if time_point_start == "未回答" && time_point_end == "未回答"
+     return
+   end
+   if time_point_start.blank? & time_point_end.blank?
+     errors.add( :time_point_start, "入力が必要です" )
+     errors.add( :time_point_end, "入力が必要です" )
+   end
+   if time_point_start? & time_point_end.blank?
+     errors.add( :time_point_end, "入力が必要です" )
+   end
+   if time_point_start.blank? & time_point_end?
+     errors.add( :time_point_start, "入力が必要です" )
+   end
+ end
+
+ def start_to_end
+   if ( time_point_start.blank? | time_point_end.blank? ) || 
+      ( time_point_start == "未回答" && time_point_end == "未回答" )
+     return
+   end
+   if time_point_start.split(":")[0].to_i() == time_point_end.split(":")[0].to_i()
+     if time_point_start.split(":")[1].to_i() >= time_point_end.split(":")[1].to_i()
+       errors.add( :time_point_start, "不正な値です" )
+       errors.add( :time_point_end, "不正な値です" )
+     end
+   end
+   if time_point_start.split(":")[0].to_i() > time_point_end.split(":")[0].to_i()
+       errors.add( :time_point_start, "不正な値です" )
+       errors.add( :time_point_end, "不正な値です" )
+   end
+ end
end
```

### 管理画面の日本語化

```diff
# config/locales/01_model/ja.yml

@@ -22,6 +22,7 @@ ja:
    group_project_name: 企画名
    stage: ステージ
    group_manager_common_option: アプリ共通設定
+   assign_stage: 使用ステージ
  attributes:
      group:
     name: 運営団体の名称

@@ -148,3 +149,13 @@ ja:
    group_manager_common_option:
      cooking_start_time: 調理開始時間
      date_of_stool_test: 検便実施日
+   assign_stage:
+     stage_order: 団体名
+     fes_date: 開催日
+     is_sunny: 天候
+     order_time_start: 希望時刻(開始)
+     order_time_end: 希望時刻(終了)
+     order_time_interval: 希望時間幅
+     stage: 使用ステージ
+     time_point_start: 開始時刻
+     time_point_end: 終了時刻
```

### cancancanの制御権限を追加

管理者から削除権限をなくす

```diff
# app/models/ability.rb

       cannot [:create, :destroy], RentalItemAllowList # 作成・削除不可
+      cannot [:destroy], AssignStage  # 削除不可
     end
     if user.role_id == 3 then # for user(デフォルトのrole)
       can :manage, :welcome
```

### validateに合わせてrake taskを変更

validateを変更すると, rake タスクがvalidateを通らなくなった.   
そのため, rakeタスクの一部を変更.  

具体的には, ``find_or_create_by`` -> ``find_or_initialize_by``に変更.  
かつ, ``save(validate: false)``を使うことでvalidateを無視.  


```diff
# lib/tasks/assign_stage.rake

 namespace :assign_stage do
   task initialize_records: :environment do
-    empty = "未入力"
-    Stage.find_or_create_by(id:0, name_ja:empty)
+    empty = "未回答"
+    Stage.find_or_create_by(id: 0) do |s|
+      s.name_ja = empty
+    end
     StageOrder.all.each do |ord|
-      AssignStage.find_or_create_by(stage_order_id: ord.id) do |as|
-        as.stage_id = 0
-        as.time_point_start = empty
-        as.time_point_end   = empty
-      end
+      as = AssignStage.find_or_initialize_by(stage_order_id: ord.id)
+      as.stage_id = 0
+      as.time_point_start = empty
+      as.time_point_end   = empty
+      as.save(validate: false) if as.new_record?
     end
   end
 end
```

### ステージ団体生成時に初期レコードを生成する処理を追加

ステージ団体を生成した際に,   
場所決定用のレコードを初期化する.  

呼び出し元(controller)

```diff
# app/controllers/groups_controller.rb
         @group.init_stage_order # ステージ企画用のレコードを生成
         @group.init_place_order # 実施場所申請用のレコードを生成
         @group.init_stage_common_option # ステージ企画の共通項目のレコードを生成
+        @group.init_assign_stage # ステージ団体使用場所用のレコードを生成

         format.html { redirect_to @group , notice: 'Group was successfully created .' }
```


呼び出されるメソッド(model)

```diff
# app/models/group.rb

     order.save
   end

+  # ステージ企画の場所決定用のレコードを生成
+  def init_assign_stage
+    return unless group_category_id == 3 # ステージ企画でなければ戻る
+    return unless orders = StageOrder.where(group_id: id)
+    empty = "未回答"
+
+    Stage.find_or_create_by(id: 0, name_ja:"未入力")
+
+    orders.each do |ord|
+      as = AssignStage.find_or_initialize_by(stage_order_id: ord.id)
+      as.stage_id = 0
+      as.time_point_start = empty
+      as.time_point_end   = empty
+      as.save(validate: false) if as.new_record?
+    end
+  end
```

