class CreatePinItems < ActiveRecord::Migration
  def self.up
    create_table :pin_items do |t|
      t.string :image_url
      t.text :description
      t.integer :user_id
      t.integer :pin_type, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :pin_items
  end
end
