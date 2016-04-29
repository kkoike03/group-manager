ActiveAdmin.register StageOrder do

  permit_params :group_id, :fes_date_id, :is_sunny, :stage_first, :stage_second, :time, :own_equipment, :bgm, :camera_permittion, :loud_sound


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
end
