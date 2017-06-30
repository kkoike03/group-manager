ActiveAdmin.register SubRep do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  permit_params :group_id, :name_ja, :name_en, :department_id, :grade_id, :tel,
                :email

  index do
    selectable_column
    id_column
    column :group
    column :name_ja
    column :name_en
    column :email
    actions
  end

  preserve_default_filters!
  filter :fes_year

end
