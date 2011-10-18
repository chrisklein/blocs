require 'spec_helper'

describe Blocpost do
  before(:each) do
    @bloc = Factory(:bloc)
    @attr = { :content => "bloc post content" }
  end  
  
  it "should create a new instance given valid attributes" do
    @bloc.blocposts.create!(@attr)
  end  
  
  describe "user associations" do

    before(:each) do
      @blocpost = @bloc.blocposts.create(@attr)
    end

    it "should have a user attribute" do
      @blocpost.should respond_to(:bloc)
    end

    it "should have the right associated user" do
      @blocpost.bloc_id.should == @bloc.id
      @blocpost.bloc.should == @bloc
    end
  end
end
