ActiveAdmin.register AssignRentalItem do


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

  permit_params :rental_order_id, :rentable_item_id, :num

  index do
    selectable_column
    id_column
    column :rental_order
    column :rentable_item
    actions
  end

end
