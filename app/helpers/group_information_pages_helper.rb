module GroupInformationPagesHelper
  def get_place_by_group(group_id)
    place = AssignGroupPlace.find_by_group(group_id).first.try(:place_id)
    Place.where(id: place).first.to_s
  end

  def get_assign_rental_items_by_group(group_id)
    AssignRentalItem.find_by_group(group_id)
  end

  def find_assign_rental_item_by_rental_item_id(assign_rental_items, rental_item_id)
    assign_rental_items.joins(rentable_item: [:stocker_item])
        .where(stocker_items: {rental_item_id: rental_item_id}).where(num: 1..Float::INFINITY)
  end
end
