# issue204

管理画面で年度項目の絞込検索できるようにする

# 対応ページ一覧

- StageOrder
- StageCommonOption
- GroupProjectName
- AssignStage
- AssignGroupPlace
- PowerOrder
- SubRep
- Group
- PlaceOrder
- Employee
- RentalOrder
- FoodProduct
- AssignRentalItem

# 年度絞込項目の追加

`FesYear` モデルとアソシエーションが設定されていないモデルではシンボル `:fes_year` を解決できません．なので，まずはアソシエーションを設定します．
とりあえず， `StageOrder` の設定例を示します．


```diff
--- a/app/models/stage_order.rb
+++ b/app/models/stage_order.rb
@@ -1,6 +1,7 @@
 class StageOrder < ActiveRecord::Base
    belongs_to :group
       belongs_to :fes_date
       +  has_one :fes_year, through: :fes_date

          validates :group_id, :fes_date_id, presence: true
             validates :group_id, :uniqueness => {:scope => [:fes_date_id, :is_sunny] } # 日付と天候でユニーク
```

次に管理画面に絞込項目を追加します．

```diff
--- a/app/admin/stage_order.rb
+++ b/app/admin/stage_order.rb
@@ -88,4 +88,8 @@ ActiveAdmin.register StageOrder do
     end
          active_admin_comments
             end
             +
             +  preserve_default_filters!
             +  filter :fes_year
             +
              end
```

これで，管理画面に年度絞込項目が追加されました．
後はこれを繰り返すだけです．
