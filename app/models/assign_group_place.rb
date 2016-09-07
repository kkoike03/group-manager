class AssignGroupPlace < ActiveRecord::Base
  belongs_to :place_order
  belongs_to :place
  validates_presence_of :place_order_id, :place_id
  validates :place_order_id, uniqueness: {scope: [:place_id] }

  scope :find_by_group, -> (group_id) {joins(:place_order).where(place_orders: {group_id: group_id})}
end
