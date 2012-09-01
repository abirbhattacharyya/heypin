class AddImageUrlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :image_url, :string, :default => "/images/default_pic.jpeg"
  end

  def self.down
    remove_column :users, :image_url
  end
end
