namespace :assign_stage do
  task initialize_records: :environment do
    empty = "未入力"
    Stage.find_or_create_by(id:0, name_ja:empty)
    StageOrder.all.each do |ord|
      AssignStage.find_or_create_by(stage_order_id: ord.id) do |as|
        as.stage_id = 0
        as.time_point_start = empty
        as.time_point_end   = empty
      end
    end
  end

end
