class AssignRentalItem < ActiveRecord::Base
  belongs_to :rental_order
  belongs_to :rentable_item
  has_one :fes_year, through: :rental_order

  validates_presence_of :rental_order_id, :rentable_item_id, :num
  validates :num, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :rental_order_id, uniqueness: {scope: [:rentable_item_id] }
  validate :valid_item  # カスタムバリデートを実行
  validate :valid_total_orders  # カスタムバリデートを実行
  validate :valid_total_rentables  # カスタムバリデートを実行

  scope :year, -> (year) {joins(rental_order: [:group]).where(groups: {fes_year_id: year})}
  scope :find_by_group, -> (group_id) {joins(:rental_order).where(rental_orders: {group_id: group_id})}

  def valid_item
    return if rental_order.rental_item_id == rentable_item.stocker_item.rental_item_id
    # not equal
    errors.add(:rental_order_id, "希望物品と貸出物品は同一にしてください")
    errors.add(:rentable_item_id, "希望物品と貸出物品は同一にしてください")
  end

  def sum_for_orders
    # 保存済み中で同じrental_orderに割り当てた数，ただしselfの数量を除く
    # (where.notが無いとselfのDB内の値も総数に含まれてしまう)
    # DBの値ではなく，今回の入力値self.numで総数を計算する．
    excepe_self = AssignRentalItem
      .where(rental_order_id: self.rental_order_id)
      .where.not(id: self.id)
      .sum(:num)
    return excepe_self + self.num
  end

  def valid_total_orders
    # 割当総数が希望数を上回らないこと
    return if self.sum_for_orders <= self.rental_order.num
    errors.add(:num,
      "割当の総数は希望数以下にしてください (" +
      "希望数" + self.rental_order.num.to_s + "に対して合計" +
      self.sum_for_orders.to_s + "を割り当てようとしています)"
    )
  end

  def sum_for_rentables
    # 保存済み中で同じrentable_itemに割り当てた数，ただしselfの数量を除く
    # (where.notが無いとselfのDB内の値も総数に含まれてしまう)
    # DBの値ではなく，今回の入力値self.numで総数を計算する．
    excepe_self = AssignRentalItem
      .where(rentable_item_id: self.rentable_item_id)
      .where.not(id: self.id)
      .sum(:num)
    return excepe_self + self.num
  end

  def valid_total_rentables
    # 割当総数が貸出可能数を上回らないこと
    return if self.sum_for_rentables <= self.rentable_item.max_num
    errors.add(:num,
      "割当の総数は割当可能数以下にしてください (" +
      "割当可能総数" + self.rentable_item.max_num.to_s + "に対して合計" +
      self.sum_for_rentables.to_s + "を割り当てようとしています)"
    )
  end

end
