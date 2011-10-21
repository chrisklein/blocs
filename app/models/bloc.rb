class Bloc < ActiveRecord::Base
  attr_accessible :content
  
  self.include_root_in_json = false
  
  belongs_to :user
  has_many :blocposts
  
  validates :content, :presence => true, :length => { :maximum => 240}
  validates :user_id, :presence => true
  
  default_scope :order => ' blocs.created_at DESC'
  
  def to_json(options = {})
    super(options.merge(:only => [ :id, :content, :created_at, :user_id ]))
  end  
end
