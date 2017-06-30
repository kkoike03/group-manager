class AssignStage < ActiveRecord::Base
  belongs_to :stage_order
  belongs_to :stage
  has_one :fes_year, through: :stage_order

  validates_presence_of :stage_order_id, :stage_id
  validate :time_is_only_selected, :start_to_end

  def time_is_only_selected
    if time_point_start == "未回答" && time_point_end == "未回答"
      return
    end
    if time_point_start.blank? & time_point_end.blank?
      errors.add( :time_point_start, "入力が必要です" )
      errors.add( :time_point_end, "入力が必要です" )
    end
    if time_point_start? & time_point_end.blank?
      errors.add( :time_point_end, "入力が必要です" )
    end
    if time_point_start.blank? & time_point_end?
      errors.add( :time_point_start, "入力が必要です" )
    end
  end

  def start_to_end
    if ( time_point_start.blank? | time_point_end.blank? ) || ( time_point_start == "未回答" && time_point_end == "未回答" )
      return
    end
    if time_point_start.split(":")[0].to_i() == time_point_end.split(":")[0].to_i()
      if time_point_start.split(":")[1].to_i() >= time_point_end.split(":")[1].to_i()
        errors.add( :time_point_start, "不正な値です" )
        errors.add( :time_point_end, "不正な値です" )
      end
    end
    if time_point_start.split(":")[0].to_i() > time_point_end.split(":")[0].to_i()
        errors.add( :time_point_start, "不正な値です" )
        errors.add( :time_point_end, "不正な値です" )
    end
  end
end
