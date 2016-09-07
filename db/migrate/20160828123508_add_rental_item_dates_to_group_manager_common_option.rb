class AddRentalItemDatesToGroupManagerCommonOption < ActiveRecord::Migration
  def change
    add_column :group_manager_common_options, :rental_item_day, :string
    add_column :group_manager_common_options, :rental_item_time, :string
    add_column :group_manager_common_options, :return_item_day, :string
    add_column :group_manager_common_options, :return_item_time, :string
  end
end
