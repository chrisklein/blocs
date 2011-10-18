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
  
  describe "validations" do
    
    it "should have a user id" do
      Bloc.new(@attr).should_not be_valid
    end  
    
    it "should require nonblank content" do
      @user.blocs.build(:content => "  ").should_not be_valid
    end  
    
    it "should reject long content" do
      @user.blocs.build(:content => "a" * 241).should_not be_valid
    end
  end
  
  describe "blocpost associations" do

    before(:each) do
      @bloc = Bloc.create(@attr)
    end

    it "should have a blocposts attribute" do
      @bloc.should respond_to(:blocposts)
    end
  end  
end
