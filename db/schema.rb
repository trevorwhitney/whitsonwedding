# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150217030850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guests", force: :cascade do |t|
    t.string "email",      limit: 255
    t.string "first_name", limit: 255
    t.string "last_name",  limit: 255
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id"
    t.string  "ip_address",   limit: 255
    t.string  "access_token", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string  "email",           limit: 255
    t.string  "password_digest", limit: 255
    t.string  "password_salt",   limit: 255
    t.integer "guest_id",                    null: false
  end

  add_index "users", ["guest_id"], name: "index_users_on_guest_id", using: :btree

  add_foreign_key "users", "guests"
end
