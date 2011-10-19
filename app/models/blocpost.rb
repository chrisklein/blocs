class Blocpost < ActiveRecord::Base
  attr_accessible :content, :bloc_id
  
  belongs_to :bloc
  belongs_to :user
end
