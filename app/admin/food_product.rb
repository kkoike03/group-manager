ActiveAdmin.register FoodProduct do

  permit_params :group_id, :name, :num, :is_cooking

  index do
    selectable_column
    id_column
    column :group
    column :name
    column :first_day_num
    column :second_day_num
    column :is_cooking
    column :start do
      GroupManagerCommonOption.first.cooking_start_time
    end
    actions
  end

  csv do
    column :id
    column :group_name do |product|
      product.group.name
    end
    column :name
    column :first_day_num
    column :second_day_num
    column :is_cooking
    column :start do
      GroupManagerCommonOption.first.cooking_start_time
    end
  end

  preserve_default_filters!
  filter :fes_year

end
