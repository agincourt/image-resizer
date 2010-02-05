ImageEditor::Application.routes.draw do |map|

  root :to => "assets#new"
  
  resources :assets, :only => [ :index, :new, :create, :show ] do
    resources :resizes, :only => [ :new, :create, :show ]
  end

end