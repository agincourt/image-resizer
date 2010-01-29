require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  should_have_instance_methods :identifier, :identifier=
  #should_have_attached_file :attachment
  #should_validate_attachment_presence :attachment
  #should_validate_attachment_content_type :attachment
  #should_validate_attachment_size :attachment, :less_than => 10.megabytes
end
