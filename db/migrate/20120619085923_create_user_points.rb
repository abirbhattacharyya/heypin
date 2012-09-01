class CreateUserPoints < ActiveRecord::Migration
  def self.up
    create_table :user_points do |t|
      t.integer :user_id
      t.integer :pin_item_id
      t.integer :point_type
      t.integer :points

      t.timestamps
    end
  end

  def self.down
    drop_table :user_points
  end
end
