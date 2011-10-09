Webdb::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user_registers", :passwords => "user_passwords"} do
  get "/users/edit_password", :to => "user_registers#edit_password" #allow users to edit their own password
  put "/users/update_password", :to => "user_registers#update_password" #allow users to edit their own password
end

  namespace :management do
    resources :systems do
      post :create, :on => :member
    end

    resources :colour_schemes
    resource :overview do 
      get :index, :on => :collection
    end#, :only => [:index]
  end

  resources :users, :only => [:show] do

    collection do
      get :access_requests
      get :index
      get :admin
      get :list
    end

    member do
      put :reject
      put :reject_as_spam
      put :deactivate
      put :activate
      get :edit_role
      put :update_role
      get :edit_approval
      put :approve

    end
  end

  resources :systems do #, :only => [:show] do
    resources :data_objects
    resources :security_groups
    member do
      get :list_members
      get :list_administrators
      get :list_collaborators
    end
  end

  root :to => "pages#home"

  get "pages/home"

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'


# This should always be the last route
# It is here to handle routing errors
# It should match every route not already matched
# Solution taken from http://techoctave.com/c7/posts/36-rails-3-0-rescue-from-routing-error-solution
  match '*a', :to => 'pages#routing_error' unless Rails.env.development?
end
