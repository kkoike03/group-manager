ActiveAdmin.register RentalOrder do


  permit_params :num

  index do
    selectable_column
    id_column
    column :group
    column :rental_item
    column :num
    actions
  end

  form do |f|
    panel '編集上の注意' do
      "数量のみ変更可能です. グループと物品は変更できません. "
    end
    f.inputs do
    input :group
    input :rental_item
    input :num
    end
    actions
  end

  csv do
    column :id
    column :group do |order|
      order.group.name
    end
    column :rental_item do |order|
      order.rental_item.name_ja
    end
    column :num
  end

  preserve_default_filters!
  filter :fes_year

end
