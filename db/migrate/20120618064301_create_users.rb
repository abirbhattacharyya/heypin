class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :name
      t.integer :uid, :limit => 6
      t.string :provider
      t.string :remember_token
      t.string :secret_token

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
