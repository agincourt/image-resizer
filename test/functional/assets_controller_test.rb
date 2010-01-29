require 'test_helper'

class AssetsControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup { get :index }
    should_assign_to :assets
    should_respond_with :success
    should_render_template :index
  end
  
  context "on GET to new" do
    setup { get :new }
    should_assign_to :asset
    should_respond_with :success
    should_render_template :new
  end
  
  context "on POST to create" do
    setup {
      post :create, :asset => { :attachment => fixture_file_upload('image.png', 'image/png') }
    }
    should_assign_to :asset
    should_respond_with :redirect
    should_change("the number of assets", :by => 1) { Asset.count }
  end
end
