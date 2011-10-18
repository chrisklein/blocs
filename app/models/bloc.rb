class Bloc < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  
  validates :content, :presence => true, :length => { :maximum => 240}
  validates :user_id, :presence => true
  
  default_scope :order => ' blocs.created_at DESC'
end
