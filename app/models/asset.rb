require 'digest/sha2'
require 'ftools'
require 'system_timer'

class Asset < ActiveRecord::Base
  # mix-ins
  has_attached_file :attachment,
    :styles => { :compressed => ["1600x1600>", :jpg], :thumbnail => ["200x200>", :jpg] },
    :whiny_thumbnails => true
  
  # validation
  validates_presence_of :identifier
  validates_uniqueness_of :identifier
  
  validates_attachment_presence :attachment
  validates_attachment_content_type :attachment, :content_type => ['image/pjpeg', 'image/gif', 'image/x-png', 'image/png', /^image\/jpe?g$/], :message => 'must be a JPEG, PNG or GIF image'
  validates_attachment_size :attachment, :less_than => 10.megabytes
  
  # actions
  before_validation :generate_identifier
  
  def custom_resize(options = {})
    options[:params] ||= {}
    # filter our parameters
    params = [:width, :height, :top, :left, :right, :bottom].inject({}) { |hsh,key|
      hsh.merge!({ key => (options[:params][key] || 0).to_i })
    }
    # generate a hash to uniquely identify this
    options[:token] ||= Digest::SHA512.hexdigest("#{params.inspect}")[0..63]
    # where the file is located relative to public
    path = resize_url(options[:token])
    # where to save the file
    save_to = "#{Rails.root}/public#{path}"
    # if the file doesn't already exist
    unless File.exist?(save_to)
      SystemTimer.timeout_after(30.seconds) do
        # process the thumbnail
        builder = Paperclip::Thumbnail.new(attachment, {
          :geometry => "#{params[:width]}x#{params[:height]}!",
          :convert_options => "-crop #{params[:width] - params[:left] - params[:right]}x#{params[:height] - params[:top] - params[:bottom]}+#{params[:left]}+#{params[:top]}! -background white  -flatten", 
          :format => :jpg,
          :qualty => 100
        })
        thumbnail = builder.make
        # save it
        File.makedirs(File.dirname(save_to))
        File.move(thumbnail.path, save_to)
        File.chmod(0644, save_to)
        thumbnail.close!
      end
    end
    
    options[:token]
  end
  
  def resize_url(token)
    token.gsub!(/[^a-f0-9]/, '')
    "/system/attachments/#{id}/#{token}/#{File.basename(attachment.path)}"
  end
  
  private
  def generate_identifier
    self.identifier ||= Digest::SHA512.hexdigest("#{Time.now}:#{rand(10000)}")[0..31]
  end
end
