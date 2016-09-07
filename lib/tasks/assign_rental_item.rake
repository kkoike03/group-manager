namespace :assign_rental_item do

  task init_this_year: :environment do
    # 今年度の希望レコードと貸出可能物品のレコードを取得
    this_year = FesYear.this_year()
    orders = RentalOrder.year(this_year)
    rentables = RentableItem.year(this_year)
    # 全組み合わせにたいして検索．無ければ生成
    orders.each do |order|
      rentables.each do |rentable|
        AssignRentalItem.find_or_create_by(
          rental_order_id: order.id, rentable_item_id: rentable.id
        ) do |user|
          user.num = 0
        end
      end
    end
  end
end
