class ResizesController < ApplicationController
  before_filter :load_asset
  
  def new
  end
  
  def create
    @token = @asset.custom_resize(:params => params[:resize])
    @resized_file = @asset.resize_url(@token)
    
    respond_to do |format|
      format.html
      format.xml { render :xml => { :token => @token, :url => @resized_file } }
    end
  end
  
  def show
    if Rails.env == 'production'
      head(:x_accel_redirect => "#{Rails.root}/public#{@asset.resize_url(params[:id])}",  
        :content_type => 'image/jpeg',  
        :content_disposition => "attachment; filename=\"#{File.basename(@asset.attachment.path)}\"")
    else
      send_file "#{Rails.root}/public#{@asset.resize_url(params[:id])}",
        :type => 'image/jpeg'
    end
  end
  
  protected
  def load_asset
    @asset = Asset.find_by_identifier(params[:asset_id])
  end
end
