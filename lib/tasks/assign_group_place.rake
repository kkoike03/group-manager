namespace :assign_group_place do
  task initialize_records: :environment do
    Place.find_or_create_by(id:0, name_ja:"未入力")
    PlaceOrder.all.each do |ord|
      AssignGroupPlace.find_or_create_by(place_order_id: ord.id) do |agp|
        agp.place_id = 0
      end
    end
  end
end
