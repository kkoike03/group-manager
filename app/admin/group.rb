ActiveAdmin.register Group do

  permit_params :user_id, :name, :group_category_id, :activity, :first_question,
                :fes_year_id

  index do
    selectable_column
    id_column
    column :fes_year
    column :user
    column :name
    column :group_category
    column :activity
    column :created_at
    actions
  end

  csv do
    column :id
    column :fes_year
    column :user do |group|
      group.user.user_detail.name_ja
    end
    column :user do |group|
      group.user.user_detail.name_en
    end
    column :name
    column :group_category do |group|
      group.group_category.name_ja
    end
    column :activity
    column :created_at
    column :updated_at
  end

  show do
    attributes_table do
      row :id
      row :name
      row :group_category_id
      row :user_name do |group|
        group.user.user_detail.name_ja
      end

      row :user_id
      row :user_tel do |group|
        group.user.user_detail.tel
      end
      row :subrep_name do |group|
        group.sub_reps.map(&:name_ja).join(", ")
      end
      row :subrep_tel do |group|
        group.sub_reps.map(&:tel).join(", ")
      end
      row :activity
      row :first_question
      row :created_at
      row :updated_at
      row :fes_year_id
    end
    active_admin_comments
  end
end
