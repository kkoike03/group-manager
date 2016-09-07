ActiveAdmin.register GroupManagerCommonOption do

  permit_params :cooking_start_time, :date_of_stool_test, :rental_item_day, :rental_item_time, :return_item_day, :return_item_time

  index do
    selectable_column
    id_column
    column :cooking_start_time
    column :date_of_stool_test
    column :rental_item_day
    column :rental_item_time
    column :return_item_day
    column :return_item_time
    actions
  end

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


end
