ActionController::Routing::Routes.draw do |map|
  map.root :controller => "home"
  
  map.connect "/auth/:provider/callback", :controller => "users", :action => "create"
  map.connect "/auth/failure", :controller => "users", :action => "failure"
  
  map.callback "/callback", :controller => "users", :action => "callback"
  
  map.logout "/logout", :controller => "users", :action => "destroy"
  map.login "/login", :controller => "users", :action => "login"

  map.search "/search", :controller => "home", :action => "search"
  map.winners "/winners", :controller => "home", :action => "winners"
  
  map.addpin "/addpin", :controller => "users", :action => "upload_image"
  map.get_images '/get_images',:controller => "pin_items" ,:action => 'get_images'
  
  map.add_pin_item '/add_pin_item',:controller => "pin_items" ,:action => 'add_pin_item'
  map.upload_pin '/upload_pin',:controller => "pin_items" ,:action => 'upload_pin'
  
  map.resources :pin_items ,:only => [:show],
    :member => {
      :comment => [:get, :post],
      :set_like => :post,
      :set_unlike => :post,
      :effects => :get,
      :apply_effect => :post
    }
  map.user_images "/:user_id", :controller => "home", :action => "index"

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
