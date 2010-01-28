class AssetsController < ApplicationController
  def index
    session[:assets] ||= []
    @assets = Asset.find(:all, :conditions => ['identifier IN (?)', session[:assets]])
  end
  
  def new
    @asset = Asset.new
  end
  
  def create
    @asset = Asset.new(params[:asset])
    
    respond_to do |format|
      if @asset.save
        # insert the asset into our session
        session[:assets] ||= []
        session[:assets] <<  @asset.identifier
        # respond
        format.html { redirect_to asset_path(@asset.identifier) }
        format.xml  { render :xml => @asset, :status => :created }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @asset = Asset.find_by_identifier(params[:id])
  end
end
