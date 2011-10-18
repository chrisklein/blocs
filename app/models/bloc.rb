class Bloc < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  
  default_scope :order => ' blocs.created_at DESC'
end
