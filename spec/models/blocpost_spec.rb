require 'spec_helper'

describe Blocpost do
  before(:each) do
    @user = Factory(:user)
    @bloc = Factory(:bloc, :user => @user, :created_at => 1.day.ago)
    @attr = { :content => "bloc post content" }
  end  
  
  it "should create a new instance given valid attributes" do
    @user.blocposts.create!(@attr)
  end  
  
  describe "user associations" do

    before(:each) do
      @blocpost = @user.blocposts.create(@attr)
    end

    it "should have a user attribute" do
      @blocpost.should respond_to(:user)
    end

    it "should have the right associated user" do
      @blocpost.user_id.should == @user.id
      @blocpost.user.should == @user
    end
  end
  
  describe "bloc associations" do

    before(:each) do
      @blocpost = @bloc.blocposts.create(@attr)
    end

    it "should have a bloc attribute" do
      @blocpost.should respond_to(:bloc)
    end

    it "should have the right associated bloc" do
      @blocpost.bloc_id.should == @bloc.id
      @blocpost.bloc.should == @bloc
    end
  end
end
