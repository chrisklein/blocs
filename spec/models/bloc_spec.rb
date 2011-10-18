require 'spec_helper'

describe Bloc do
  
  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "fooo baaar" }
  end  
  
  it "should create a new instance with valid attributes" do 
    @user.blocs.create!(@attr)
  end  
  
  describe "user associaations" do
    
    before(:each) do
      @blocs = @user.blocs.create(@attr)
    end
    
    it "should have a user attribute" do
      @blocs.should respond_to(:user)
    end  
    
    it "should have the right associated user" do
      @blocs.user_id.should == @user.id
      @blocs.user.should == @user
    end  
    
  end  
  
end
