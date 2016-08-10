class RentalOrder < ActiveRecord::Base
  belongs_to :group
  belongs_to :rental_item
  has_many :assign_rental_item

  validates :group_id, :rental_item_id, :num, presence: true
  validates :num, numericality: {
    only_integer: true, greater_than_or_equal_to: 0
  }
  validates :group_id, :uniqueness => {:scope => :rental_item_id }

  def to_s
    self.group.name + ' (' + self.rental_item.name_ja + \
    ', 数: ' + self.num.to_s + ')'
  end
end
