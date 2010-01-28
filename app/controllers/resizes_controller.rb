class ResizesController < ApplicationController
  before_filter :load_asset
  
  def new
  end
  
  def create
    @token = @asset.custom_resize(:params => params[:resize])
    @resized_file = @asset.resize_url(@token)
  end
  
  def show
    send_file "#{Rails.root}/public#{@asset.resize_url(params[:id])}", :type => 'image/jpeg'
  end
  
  protected
  def load_asset
    @asset = Asset.find_by_identifier(params[:asset_id])
  end
end
