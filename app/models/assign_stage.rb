class AssignStage < ActiveRecord::Base
  belongs_to :stage_order
  belongs_to :stage
end
