class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy]
  
  respond_to :json, :xml
  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @blocs = @user.blocs
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, :flash => { :success => "Welcome to the Sample App." }  }
      else  
        @title = "Sign up"
        format.html { render 'new' }
      end
    end    
  end
  
  def edit
    # No @user assignment because it's created in the correct_user before filter.
    @title = "Edit user"
  end  
  
  def update
    # No @user assignment because it's create in the correct_user before filter.
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile updated." }
    else  
      @title = "Edit user"
      render 'edit'
    end  
  end
 
  def destroy
    destroyed_user = User.find(params[:id]).destroy
    redirect_to users_path, :flash => { :success => "User '#{destroyed_user.name}' has been removed."}
  end
    
  private 
    
    def correct_user
      # Because user is assinged here, I'm removing from the actions.
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end  
    
    def admin_user
      user = User.find(params[:id])
      redirect_to(root_path) if !current_user.admin? || current_user?(user)
    end

end