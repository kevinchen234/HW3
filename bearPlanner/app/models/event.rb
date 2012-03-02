class Event < ActiveRecord::Base
  belongs_to :calendar :foreign_key=>"cal_id"


end
