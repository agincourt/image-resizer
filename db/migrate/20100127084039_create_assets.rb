class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string   :attachment_file_name
      t.string   :attachment_content_type
      t.integer  :attachment_file_size
      t.datetime :attachment_updated_at
      t.string   :identifier, :limit => 32
      t.timestamps
    end
    
    add_index :assets, :identifier, :unique => true
  end

  def self.down
    drop_table :assets
  end
end
