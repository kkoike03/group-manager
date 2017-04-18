class AddColumnToPlaceOrder < ActiveRecord::Migration
  def change
    add_column :place_orders, :remark, :text
  end
end
