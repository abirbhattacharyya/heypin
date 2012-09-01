# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120620101058) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pin_item_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pin_items", :force => true do |t|
    t.string   "image_url"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "pin_type",    :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_points", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pin_item_id"
    t.integer  "point_type"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.integer  "uid",            :limit => 8
    t.string   "provider"
    t.string   "remember_token"
    t.string   "secret_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url",                   :default => "/images/default_pic.jpeg"
  end

end
