class RentableItem < ActiveRecord::Base
  belongs_to :stocker_item
  belongs_to :stocker_place
  has_many :assign_rental_item

  validates :stocker_item_id, :stocker_place_id, :max_num, presence: true
  validates :max_num, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  # validate 貸し出し可能数は在庫数以下
  validates_with RentableItemValidator, on: :create
  validates_with RentableItemValidator, on: :update

  def to_s
    self.stocker_item.rental_item.name_ja + \
    ' (' + self.stocker_item.stocker_place.name + \
    ', 数:' + self.max_num.to_s + ')'
  end
end
