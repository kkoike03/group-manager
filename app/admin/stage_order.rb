ActiveAdmin.register StageOrder do

  permit_params :group_id, :fes_date_id, :is_sunny, :stage_first, :stage_second, :time_point_start, :time_point_end, :time_interval


  index do
    selectable_column
    id_column
    column :group
    column :fes_date_id do |order|
      FesDate.find(order.fes_date_id).date
    end
    column :is_sunny do |order|
      order.tenki
    end
    column :stage_first do  |order|
      order.stage_first  ? Stage.find(order.stage_first)  : "未回答"
    end
    column :stage_second do |order|
      order.stage_second ? Stage.find(order.stage_second) : "未回答"
    end
    column :time_point_start
    column :time_point_end
    column :time_interval
    actions
  end

  csv do
    column :id
    column :group_name do  |order|
      order.group.name
    end
    column :fes_date_id do |order|
      FesDate.find(order.fes_date_id).date
    end
    column :is_sunny do |order|
      order.tenki
    end
    column :stage_first do  |order|
      order.stage_first  ? Stage.find(order.stage_first)  : "未回答"
    end
    column :stage_second do |order|
      order.stage_second ? Stage.find(order.stage_second) : "未回答"
    end
    column :time_point_start
    column :time_point_end
    column :time_interval
    column("自前の音響機材を使用する") {|order| StageCommonOption.where(group_id: order.group_id).first.own_equipment ? "Yes" : "No" }
    column("実行委員にBGMをかけるのを依頼する") {|order| StageCommonOption.where(group_id: order.group_id).first.bgm ? "Yes" : "No" }
    column("実行委員による撮影を許可する") {|order| StageCommonOption.where(group_id: order.group_id).first.camera_permittion ? "Yes" : "No" }
    column("大きな音を出す") {|order| StageCommonOption.where(group_id: order.group_id).first.loud_sound ? "Yes" : "No" }
    column("出演内容") {|order| StageCommonOption.where(group_id: order.group_id).first.stage_content }
  end

  form do |f|
    f.inputs do
      f.input :group
      f.input :fes_date_id, :as => :select, :collection => FesDate.all
      f.input :is_sunny
      f.input :stage_first, :as => :select, :collection => Stage.all
      f.input :stage_second, :as => :select, :collection => Stage.all
      f.input :time_point_start, input_html: {value: f.object.time_point_start == "未回答" ? "" : f.object.time_point_start}
      f.input :time_point_end, input_html: {value: f.object.time_point_end == "未回答" ? "" : f.object.time_point_end}
      f.input :time_interval, input_html: {value: f.object.time_interval == "未回答" ? "" : f.object.time_interval}
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :group
      row :is_sunny
      row :fes_date_id  do |order|
        FesDate.find(order.fes_date_id).date
      end
      row :stage_first do  |order|
        order.stage_first  ? Stage.find(order.stage_first)  : "未回答"
      end
      row :stage_second do |order|
        order.stage_second ? Stage.find(order.stage_second) : "未回答"
      end
      row :time_point_start
      row :time_point_end
      row :time_interval
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  preserve_default_filters!
  filter :fes_year

end
