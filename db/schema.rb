# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101128132145) do

  create_table "applications", :force => true do |t|
    t.integer  "user_id"
    t.string   "topic"
    t.integer  "reaction"
    t.integer  "closed_by_user_id"
    t.integer  "to_user_id"
    t.integer  "important"
    t.text     "content"
    t.datetime "close_date"
    t.integer  "execution"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "application_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dm_user", :force => true do |t|
    t.string   "username",                            :default => "",     :null => false
    t.string   "email",                               :default => "",     :null => false
    t.string   "algorithm",            :limit => 128, :default => "sha1", :null => false
    t.string   "salt",                 :limit => 128
    t.string   "password",             :limit => 128
    t.boolean  "is_active",                           :default => true
    t.boolean  "is_super_admin",                      :default => false
    t.datetime "last_login"
    t.string   "forgot_password_code", :limit => 12
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "phone"
    t.string   "name"
    t.string   "surname"
    t.text     "about"
    t.text     "about_band"
    t.text     "about_admin"
    t.integer  "role",                                :default => 0
  end

  add_index "dm_user", ["email"], :name => "email", :unique => true
  add_index "dm_user", ["forgot_password_code"], :name => "forgot_password_code", :unique => true
  add_index "dm_user", ["is_active"], :name => "is_active_idx_idx"
  add_index "dm_user", ["username"], :name => "username", :unique => true

  create_table "ownerships", :force => true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggables", :force => true do |t|
    t.integer  "category_id"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "name"
    t.string   "surname"
    t.string   "password"
    t.string   "email"
    t.text     "about"
    t.text     "about_band"
    t.text     "about_admin"
    t.integer  "role",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
  end

end
