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
      @responder = User.create(:name => "Example User", :email => "user@example.com", 
                               :password => "foobar", :password_confirmation => "foobar")
      @blocpost1 = @user.blocposts.create!(:content => "blocpost 1", :bloc_id => @bloc.id)
      @blocpost2 = @responder.blocposts.create!(:content => "blocpost 2", :bloc_id => @bloc.id)
      @blocpost3 = @user.blocposts.create!(:content => "blocpost 3", :bloc_id => @bloc.id)
    end

    it "should have a blocposts attribute" do
      @bloc.should respond_to(:blocposts)
    end
    
    it "should be assoicated with all blocposts" do
      [@blocpost1, @blocpost2, @blocpost3].each do |blocpost|
        Blocpost.find_by_id(blocpost.id).bloc_id.should == @bloc.id
      end
    end  
  end  
end
