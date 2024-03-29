Blocs::Application.routes.draw do
  
  resources :users
  resources :sessions, :only => [:new, :create, :destroy] 
  resources :blocs, :only => [:create, :destroy, :show, :index]
  resources :blocposts

  root :to => "pages#home"
  
  match '/contact',             :to => 'pages#contact'
  match '/about',               :to => 'pages#about'
  match '/help',                :to => 'pages#help'
  match '/signup',              :to => 'users#new'
  match '/signin',              :to => 'sessions#new'
  match '/signout',             :to => 'sessions#destroy'
  match '/test_blocposts',      :to => 'blocposts#test_blocposts'
  match 'users/api/full_index', :to => 'users#full_index' #temporary because of paging

  resources :users do
     member do
       get 'blocs'
     end  
   end  
  
  resources :users do
    resources :blocs
  end
  
  resources :users do
     member do
       get 'blocposts'
     end  
   end  
  
  resources :users do
    resources :blocposts
  end
  
  resources :blocs do
     member do
       get 'blocposts'
     end  
   end  
  
  resources :blocs do
    resources :blocposts
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
