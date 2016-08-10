namespace :assign_stage do
  task initialize_records: :environment do
    empty = "未回答"
    Stage.find_or_create_by(id: 0) do |s|
      s.name_ja = empty
    end
    StageOrder.all.each do |ord|
      as = AssignStage.find_or_initialize_by(stage_order_id: ord.id) 
      as.stage_id = 0
      as.time_point_start = empty
      as.time_point_end   = empty
      as.save(validate: false) if as.new_record?
    end
  end

end
