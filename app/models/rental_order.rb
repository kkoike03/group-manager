class RentalOrder < ActiveRecord::Base
  belongs_to :group
  belongs_to :rental_item
  has_many :assign_rental_item
  has_one :fes_year, through: :group

  validates :group_id, :rental_item_id, :num, presence: true
  validates :num, numericality: {
    only_integer: true, greater_than_or_equal_to: 0
  }
  validates :group_id, :uniqueness => {:scope => :rental_item_id }

  def to_s
    self.group.name + ' (' + self.rental_item.name_ja + \
    ', 希望数: ' + self.num.to_s +
    ', 割当必要残数: ' + self.remaining_num.to_s + ')'
  end

  scope :year, -> (year) {joins(:group).where(groups: {fes_year_id: year})}

  def assigned_num
    AssignRentalItem.where(rental_order_id: self.id).sum(:num)
  end

  def remaining_num
    # 希望数 - 割当数
    self.num - self.assigned_num
  end

end
