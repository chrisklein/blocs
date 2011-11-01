class BlocsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  respond_to :json, :xml
  def index
    @blocs = Bloc.all
  end
  
  def show
    @bloc = Bloc.find(params[:id])
  end
  
  def create
    @bloc  = current_user.blocs.build(params[:bloc])
        if @bloc.save
          @blocpost = current_user.blocposts.create!(:content => @bloc.content, :bloc_id => @bloc.id)
          flash[:success] = "Bloc created!"
          redirect_to root_path
        else
          @feed_items = []
          render 'pages/home'
        end
  end
  
  def update
    bloc = Bloc.find(params[:id])
    bloc.update_attributes! params
  end
  
  def destroy
    @bloc.destroy
    redirect_back_or root_path
  end

  private

    def authorized_user
      @bloc = current_user.blocs.find_by_id(params[:id])
      redirect_to root_path if @bloc.nil?
    end 
  
end  