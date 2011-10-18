class Blocpost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :bloc
end
