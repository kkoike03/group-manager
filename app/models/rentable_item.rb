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
    ', 割当可能な総数:' + self.max_num.to_s +
    ', 残数:' + self.remaining_num.to_s + ')'
  end

  scope :year, -> (year) {joins(:stocker_item).where(stocker_items: {fes_year_id: year})}

  def assigned_num
    AssignRentalItem.where(rentable_item_id: self.id).sum(:num)
  end

  def remaining_num
    # 割当可能総数 - 割当数
    self.max_num - self.assigned_num
  end
end
