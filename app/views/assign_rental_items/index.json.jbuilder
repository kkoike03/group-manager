json.array!(@assign_rental_items) do |assign_rental_item|
  json.extract! assign_rental_item, :id, :rental_order_id, :rentable_item_id, :num
  json.url assign_rental_item_url(assign_rental_item, format: :json)
end
