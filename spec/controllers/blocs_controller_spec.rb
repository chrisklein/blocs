require 'spec_helper'

describe BlocsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  describe "POST 'create'" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
      end

      describe "failure" do

        before(:each) do
          @attr = { :content => "" }
        end

        it "should not create a bloc" do
          lambda do
            post :create, :bloc => @attr
          end.should_not change(Bloc, :count)
        end

        it "should render the home page" do
          post :create, :bloc => @attr
          response.should render_template('pages/home')
        end
      end

      describe "success" do

        before(:each) do
          @attr = { :content => "Bloc Content" }
        end

        it "should create a bloc" do
          lambda do
            post :create, :bloc => @attr
          end.should change(Bloc, :count).by(1)
        end

        it "should redirect to the home page" do
          post :create, :bloc => @attr
          response.should redirect_to(root_path)
        end

        it "should have a flash message" do
          post :create, :bloc => @attr
          flash[:success].should =~ /bloc created/i
        end
    end
  end
  
  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

        before(:each) do
          @user = Factory(:user)
          wrong_user = Factory(:user, :email => Factory.next(:email))
          test_sign_in(wrong_user)
          @bloc = Factory(:bloc, :user => @user)
        end

        it "should deny access" do
          delete :destroy, :id => @bloc
          response.should redirect_to(root_path)
        end
    end

    describe "for an authorized user" do

        before(:each) do
          @user = test_sign_in(Factory(:user))
          @bloc = Factory(:bloc, :user => @user)
        end

        it "should destroy the micropost" do
          lambda do 
            delete :destroy, :id => @bloc
          end.should change(Bloc, :count).by(-1)
        end
    end
  end
end