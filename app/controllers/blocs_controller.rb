class BlocsController < ApplicationController
  def index
    render :json => Bloc.all
  end
  
  def show
    render :json => Bloc.find(params[:id])
  end
  
  def create
    bloc = Bloc.create! params
    render :json => bloc
  end
  
  def update
    bloc = Bloc.find(params[:id])
    bloc.update_attributes! params
    render :json => bloc
  end
end  