class AddTimeToStageOrders < ActiveRecord::Migration
  def change
    add_column :stage_orders, :time_point_start, :string
    add_column :stage_orders, :time_point_end, :string
    add_column :stage_orders, :time_interval, :string
  end
end
