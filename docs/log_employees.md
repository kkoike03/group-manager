# 従業員の募集項目作成ログ

## 基本方針

食品販売に関わる団体に従業員を登録させる．

employee_categoryモデルに担当部門を入れる．
employeeモデルに団体id，名前，学生番号，担当部門idを入れる．

## モデル生成

```
# 担当部門用
bundle exec rails g model employee_category name_ja:string name_en:string

# マイグレーション
rake db:migrate
== 20150620135916 CreateEmployeeCategories: migrating =========================
-- create_table(:employee_categories)
   -> 0.0047s
== 20150620135916 CreateEmployeeCategories: migrated (0.0048s) ================

# 初期データ投入
rake db:seed_fu
```

## CURD生成

```
bundle exec rails g scaffold employee group:references name:string student_id:integer employee_category:references duplication:boolean
```

`db/migrate/***_create_employees.rb`で`name`, `student_id`を`null: false`で指定．

```
# マイグレーション
rake db:migrate

== 20150620141736 CreateEmployees: migrating ==================================
-- create_table(:employees)
   -> 0.0215s
== 20150620141736 CreateEmployees: migrated (0.0215s) =========================
```

## boostrap適用

```
bundle exec rails g bootstrap:themed Employees

    conflict  app/views/employees/index.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/employees/index.html.erb? (enter "h" for help) [Ynaqdh] a       
    force  app/views/employees/index.html.erb
    conflict  app/views/employees/new.html.erb
       force  app/views/employees/new.html.erb
    conflict  app/views/employees/edit.html.erb
       force  app/views/employees/edit.html.erb
    conflict  app/views/employees/_form.html.erb
       force  app/views/employees/_form.html.erb
    conflict  app/views/employees/show.html.erb
       force  app/views/employees/show.html.erb
```

## welcome indexにリンクを追加

```
# app/views/welcome/index.html.erb

+<div class="panel panel-primary">
+  <div class="panel-heading">
+    <h3 class="panel-title">従業員登録</h3>
+  </div>
+  <div class="panel-body">
+    模擬店で食品を取り扱う団体はこちらから従業員を登録して下さい。<br>
+    対象: 参加形式が「模擬店(食品販売)」の団体
+    <%= link_to t('welcome_controller.index'),
+            employees_path,
+            :class => 'btn btn-default' %>
+  </div>
+</div>
```

## モデルにバリデーションを追加

* 必須入力: group_id, student_id, name, employee_category_id
* 整数のみ: group_id, student_id, employee_category_id
* 8桁の数字のみ: student_id

## views/index 修正

### indexのカラムを修正

カラムを整理．カラム名を表示する辞書ファイルを追加

### indexで表示するレコードを自分のグループのみに限定

`app/controllers/employees_controller.rb`のindexメソッドで取得するレコードを指定


## ActiveAdminの管理対象に追加

```
bundle exec rails generate active_admin:resource Employee
```

index, csvメソッド追加

## モデルにバリデーション追加

学籍番号と団体でユニークに

## フォームの修正

ヒントを追加．関係する辞書ファイルを追加
group, employee_category_idをassociationへ変更

## show 修正

duplicationを削除
辞書を指定

## 権限を設定

```
diff --git a/app/controllers/employees_controller.rb b/app/controllers/employees_controller.rb
index cbb0a11..9e0667a 100644
--- a/app/controllers/employees_controller.rb
+++ b/app/controllers/employees_controller.rb
@@ -1,6 +1,7 @@
 class EmployeesController < ApplicationController
   before_action :set_employee, only: [:show, :edit, :update, :destroy]
   before_action :get_groups # カレントユーザの所有する団体を@groupsとする
+  load_and_authorize_resource # for cancancan

   # GET /employees
   # GET /employees.json

diff --git a/app/models/ability.rb b/app/models/ability.rb
index 9441066..98eaa8a 100644
--- a/app/models/ability.rb
+++ b/app/models/ability.rb
@@ -63,6 +63,8 @@ class Ability
       can [:read, :update], StageOrder, :group_id => groups
       # 実施場所申請は自分の団体のみ読み，更新を許可
       can [:read, :update], PlaceOrder, :group_id => groups
+      # 従業員は自分の団体のみ自由に触れる
+      can :manage, Employee, :group_id => groups
       # 販売食品は自分の団体のみ自由に触れる
       can :manage, FoodProduct, :group_id => groups
     end
```
