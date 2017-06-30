ActiveAdmin.register AssignStage do

  permit_params :stage_id, :time_point_start, :time_point_end

  index do
    selectable_column
    id_column
    column :stage_order do |as|
      as.stage_order.group
    end
    column :fes_date do |as|
      FesDate.find(as.stage_order.fes_date_id)
    end

    column :is_sunny do |as|
      as.stage_order.is_sunny ? "晴天時" : "雨天時"
    end
    column :order_time_start do |as|
      as.stage_order.time_point_start
    end

    column :order_time_end do |as|
      as.stage_order.time_point_end
    end

    column :order_time_interval do |as|
      as.stage_order.time_interval
    end

    column :stage
    column :time_point_start
    column :time_point_end
    actions
  end

  form do |f|
    set_time_point
    order  = f.object.stage_order
    stages = Stage.all
    message= "未回答"

    panel "申請情報" do
      li "グループ: #{order.group}"
      li "希望場所1 : #{order.stage_first ?  stages.find(order.stage_first)  : message}"
      li "希望場所2 : #{order.stage_second ? stages.find(order.stage_second) : message}"
      li "希望開始時間 : #{order.time_point_start ? order.time_point_start : message}"
      li "希望終了時間 : #{order.time_point_end ? order.time_point_end : message}"
      li "希望時間幅 : #{order.time_interval ? order.time_interval : message}"
    end

    f.inputs '団体のステージ場所&時間決定' do
      input :stage, :as => :select, :collection => stages
      input :time_point_start, :as => :select, :collection => @time_point
      input :time_point_end, :as => :select, :collection => @time_point
    end
    f.actions
  end

  preserve_default_filters!
  filter :fes_year

end

def set_time_point
  @time_point = [["", ""]]
  (8..21).each do |h|
    %w(00 15 30 45).each do |m|
      @time_point.push ["#{"%02d" % h}:#{m}","#{"%02d" % h}:#{m}"]
    end
  end
end
