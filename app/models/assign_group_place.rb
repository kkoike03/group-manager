class AssignGroupPlace < ActiveRecord::Base
  belongs_to :place_order
  belongs_to :place
end
