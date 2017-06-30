class FoodProduct < ActiveRecord::Base
  belongs_to :group
  has_many :purchase_list
  has_many :employees, through: :group
  has_one :fes_year, through: :group

  validates_presence_of :group_id, :name, :first_day_num, :second_day_num
  validates_numericality_of :group_id, :first_day_num, :second_day_num
  # boolean型をチェック. presence_of ではfalseでエラーになってしまう
  validates :is_cooking, inclusion: {in: [true, false]}

  def to_s
    self.name
  end

  def disp_cooking
    disp = self.is_cooking ? '調理あり' : '調理なし(提供のみ)'
    return disp
  end

  # グループidで検索するスコープ
  scope :groups, -> (group_ids) {where( group_id: group_ids )}
  # 調理ありを検索するスコープ
  scope :cooking, -> {where( is_cooking: 'true' )}
  # 調理なしを検索するスコープ
  scope :non_cooking, -> {where( is_cooking: 'false' )}

  scope :cooking_products, -> (year_id) {
      cooking.joins(:group => :fes_year).merge(Group.year_groups(year_id))}

  scope :non_cooking_products,  -> (year_id) {
      non_cooking.joins(:group => :fes_year).merge(Group.year_groups(year_id))}

end
