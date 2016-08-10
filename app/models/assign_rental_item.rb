class AssignRentalItem < ActiveRecord::Base
  belongs_to :rental_order
  belongs_to :rentable_item

  validates_presence_of :rental_order_id, :rentable_item_id, :num
  validates :num, numericality: :only_integer
  validates :rental_order_id, uniqueness: {scope: [:rentable_item_id] }
end
