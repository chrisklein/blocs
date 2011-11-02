class Bloc < ActiveRecord::Base
  attr_accessible :content
  
  self.include_root_in_json = false
  
  belongs_to :user
  has_many :blocposts, :dependent => :destroy
  has_one :event
  
  validates :content, :presence => true, :length => { :maximum => 240}
  validates :user_id, :presence => true
  
  default_scope :order => ' blocs.created_at DESC' 
end
