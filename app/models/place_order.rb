class PlaceOrder < ActiveRecord::Base
  belongs_to :group
  has_one :fes_year, through: :group

  validate :select_different_stage
  validate :write_remark

  validates :group_id, presence: true
  validates :group_id, uniqueness: true

  def select_different_stage
    return if first.nil? & second.nil? & third.nil? # 全てnil(初期値)なら無効
    if [first, second, third].uniq.size < 3
        errors.add( :first , "候補が重複しています。")
        errors.add( :second, "候補が重複しています。")
        errors.add( :third , "候補が重複しています。")
    end
  end

  def write_remark
    return if first.nil? & second.nil? & third.nil? # 全てnil(初期値)なら無効
    if [first, second, third].include?(16) & remark.empty?
      errors.add( :remark, "備考欄に記述してください。")
    end
  end

  def to_s
    self.group.name
  end
end
