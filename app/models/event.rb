class Event < ActiveRecord::Base
  attr_accessible :bloc_id, :address, :phone_number, :place
  
  self.include_root_in_json = false
  
  belongs_to :bloc
  
end
