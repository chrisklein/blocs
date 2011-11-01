class BlocpostsController < ApplicationController
  
  respond_to :json, :xml
  def index
    @blocposts = Blocpost.all
  end
  
  def show
    @blocpost = Blocpost.find(params[:id])
  end
  
  def test_blocposts
    @blocpost = Blocpost.all
  end
  
end  