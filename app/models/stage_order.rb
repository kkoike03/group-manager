class StageOrder < ActiveRecord::Base
  belongs_to :group
  belongs_to :fes_date

  validates :group_id, :fes_date_id, presence: true
  validates :group_id, :uniqueness => {:scope => [:fes_date_id, :is_sunny] } # 日付と天候でユニーク
  validate :select_different_stage
  validate :time_is_only_selected, :start_to_end


  def tenki
    return is_sunny ? "晴天時" :  "雨天時"
  end

  def date
    return FesDate.find(fes_date_id).date
  end

  def select_different_stage
    return if stage_first.nil? & stage_second.nil?
    if stage_first == stage_second
        errors.add( :stage_first, "候補が重複しています。")
        errors.add( :stage_second, "候補が重複しています。")
    end
  end

  def kibou1
    return Stage.find( stage_first )
  end

  def kibou2
    return Stage.find( stage_second )
  end

  def time_is_only_selected
    if time_point_start == "未回答" && time_point_end == "未回答" && time_interval == "未回答" # レコード生成時のValidation回避
      return
    end
    if time_point_start.empty? & time_point_end.empty? & time_interval.empty?
      errors.add( :time_point_start, "入力が必要です" )
      errors.add( :time_point_end, "入力が必要です" )
      errors.add( :time_interval, "入力が必要です" )
    end
    if ( time_point_start? | time_point_end? ) & time_interval?
      errors.add( :time_point_start, "どちらかのみ入力してください" )
      errors.add( :time_point_end, "どちらかのみ入力してください" )
      errors.add( :time_interval, "どちらかのみ入力してください" )
    end
    if time_point_start? & time_point_end.empty?
      errors.add( :time_point_end, "入力が必要です" )
    end
    if time_point_start.empty? & time_point_end?
      errors.add( :time_point_start, "入力が必要です" )
    end
  end

  def start_to_end
    if ( time_point_start.empty? | time_point_end.empty? ) || ( time_point_start == "未回答" && time_point_end == "未回答" )
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
