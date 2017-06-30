class PowerOrder < ActiveRecord::Base
  belongs_to :group
  has_one :fes_year, through: :group

  validates :group_id, :item, :power, :manufacturer, :model, presence: true # 必須項目

  scope :year, -> (year) {joins(:group).where(groups: {fes_year_id: year})}

  def stage?
    group_category = Group.find(group_id).group_category_id
    if 3 == group_category
      return true
    end
    return false
  end


  validates :power,     if: :stage?, numericality: { 
    only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 2500,
  }

  validates :power, unless: :stage?, numericality: { 
    only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000,
  } 

  validates_with PowerOrderCreateValidator, on: :create
  validates_with PowerOrderUpdateValidator, on: :update

end
