class CreateAssignStages < ActiveRecord::Migration
  def change
    create_table :assign_stages do |t|
      t.references :stage_order, index: true, foreign_key: true
      t.references :stage, index: true, foreign_key: true
      t.string :time_point_start
      t.string :time_point_end

      t.timestamps null: false
    end
  end
end
