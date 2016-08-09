class CreateAssignGroupPlaces < ActiveRecord::Migration
  def change
    create_table :assign_group_places do |t|
      t.references :place_order, index: true, foreign_key: true, null:false
      t.references :place, index: true, foreign_key: true, null:false

      t.timestamps null: false
    end
  end
end
