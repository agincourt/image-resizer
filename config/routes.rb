ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'assets', :action => 'new'
  map.resources :assets, :only => [ :index, :new, :create, :show ] do |asset|
    asset.resources :resizes, :only => [ :new, :create, :show ]
  end
end
