require 'spec_helper'

describe UsersController do
  render_views
     
  describe "GET 'index'" do
    
    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end  
    end  
      
    describe "for signed-in users" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        33.times do
          Factory(:user, :email => Factory.next(:email))
        end  
      end  
      
      it "should allow access" do
        get :index
        response.should be_success
      end  
      
      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => "All users")
      end  
      
      it "should have an element for each user" do
        get :index
        User.paginate(:page => 1).each do |user|
          response.should have_selector('li', :content => user.name)
        end  
      end   
      
      # it "should paginate users" do
      #   get :index
      #   response.should have_selector('div.pagination')
      #   response.should have_selector('span.disabled', :content => "Previous")
      #   response.should have_selector('a', :href => "/users?page=2",
      #                                       :content => "2")
      #   response.should have_selector('a', :href => "/users?page=2",
      #                                       :content => "Next")                                    
      # end  
      
       it "should not have a delete link for admins" do
         other_user = User.all.second
         get :index
         response.should_not have_selector('a', :href => user_path(other_user),
                                                :content => "delete")
       end
       
       it "should have a delete link for admins" do
         @user.toggle!(:admin)
         other_user = User.all.second
         get :index
         response.should have_selector('a', :href => user_path(other_user),
                                            :content => "delete")
       end
    end
      
  end  
  
  describe "GET show" do
     
    before(:each) do
      @user = Factory(:user)
      @user1 = User.create(:name => "Example User 1", :email => "user1@blocs.com", :password => "foobar", :password_confirmation => "foobar")
      @user2 = User.create(:name => "Example User 2", :email => "user2@blocs.com", :password => "foobar", :password_confirmation => "foobar")
      @bloc_attr = { :content => "bloc" }
      @blocpost_attr = { :content => "bloc post" }
      @bloc = @user1.blocs.create!(@bloc_attr)
      @blocpost1 = @user1.blocposts.create!(:content => "first blocpost", :bloc_id => @bloc.id)
    end  
  
    it "should be succesful" do
      get :show, :id => @user
      response.should be_success
    end
  
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end  
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name)
    end  
    
    it "should have the right user's name" do
      get :show, :id => @user
      response.should have_selector('h1', :content => @user.name)
    end  
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector('h1>img', :class => "gravatar")
    end  
    
    it "should have the right url for the user" do
      get :show, :id => @user
      response.should have_selector('div > a', :content => user_path(@user),
                                            :href    => user_path(@user))
    end  
    
    it "should show the user's blocs" do
      bloc1 = Factory(:bloc, :user => @user, :content => "Foo bar") 
      bloc2 = Factory(:bloc, :user => @user, :content => "Bar baz") 
      get :show, :id => @user
      response.should have_selector(".content", :content => bloc1.content)
      response.should have_selector(".content", :content => bloc2.content)
    end  
    
    it "should show blocposts within blocs" do
      
    end  
  end  

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign up")
    end  
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end  
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector('title', :content => "Sign up")
      end  
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)  
      end    
    end 
      
    describe "success" do
      
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com", :password => "foobar",
                  :password_confirmation => "foobar" }
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)  
      end   
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end  
      
      it "should have a welcome messsage" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end  
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end  
    end 
  end
     
  describe "GET 'edit" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end  
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end  
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => "Edit user")
    end
    
    it "should have a link to change gravatar" do
      get :edit, :id => @user
      response.should have_selector('a', :href => 'http://gravatar.com/emails',
                                         :content => "change")
    end  
    
    it "should have an import google contacts div" do
       get :edit, :id => @user
       response.should have_selector('div', :class => "google-apis")
    end    
  end  
  #   
  #   # I'm not 100% sure this is the right action yet
  #   describe "POST 'authenticate_goole_api" do
  #     
  #     describe "failure" do
  #       
  #     end
  #     
  #     describe "success" do
  #       
  #     end    
  #   end  
  #   
  describe "PUT 'update" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end   
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector('title', :content => "Edit user")
      end  
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name => "New Name", :email => "new@example.com", :password => "barfoo",
                  :password_confirmation => "barfoo" }
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        # assigns @user from controller to local user variable.
        # by using assing(:user) to get @user from controller.
        user = assigns(:user)
        @user.reload
        @user.name.should == user.name
        @user.email.should == user.email
        @user.encrypted_password.should == user.encrypted_password
      end  
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end  
    end    
  end  
     
  describe "authentication of edit/update actions" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end  

      it "should deny access to 'edit'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end  
    
    describe "for signed-in users" do
    
      before(:each) do
        wrong_user = Factory(:user, :email => "user@examp.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end  
      
      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end  
  end  
     
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
    end  
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end  
    end
    
    describe "as a non-admin user" do
      it "should protect the action" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end  
    
    describe "as an admin user" do
      
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end  
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)  
      end
        
      it "should redirect to the users index page" do
        delete :destroy, :id => @user
        flash[:success].should =~ /removed/i
        response.should redirect_to(users_path)
      end  
      
      it "should not be able to destroy itself" do
        lambda do
          delete :destroy, :id => @admin
        end.should_not change(User, :count)  
      end  
    end    
  end  
  
end
