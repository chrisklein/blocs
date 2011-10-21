class BlocsController < ApplicationController
  
  respond_to :json, :xml
  def index
    @bloc = Bloc.all
  end
  
  def show
    @bloc = Bloc.find(params[:id])
  end
  
  def create
     bloc = Bloc.create! params
  end
  
  def update
    bloc = Bloc.find(params[:id])
    bloc.update_attributes! params
  end
  
end  