# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessor   :password #attr_accessor only applies to models in memory.
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :blocs, :dependent => :destroy
  
  has_many :blocposts
  
  email_regex = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i
  
  validates :name,     :presence     => true,
                       :length       => { :maximum => 50 }
  
  validates :email,    :presence     => true,
                       :format       => { :with => email_regex },
                       :uniqueness   => { :case_sensitive => false }
  
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 } 
                       
  
  before_save :encrypt_password
  
  def as_json(options = {})
    super(options.merge( :includ => { :blocs => { :include => :blocposts }}))
  end  

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  # This self refers to the Class, not instance.  It could also be written as
  #
  # class << self
  #   def authenticate(email, submitted_password)
  #   endrequire 'user'
  
  # end
  #
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password)) ? user : nil
  end  
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end  
  
  ######### End of class methods  ###################
                       
  private
    
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(self.password)
    end  
    
    def encrypt(string)
      secure_hash("#{self.salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{self.password}")
    end  
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
                                        
end
