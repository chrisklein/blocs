class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
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

end
