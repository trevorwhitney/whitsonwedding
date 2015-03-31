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

ActiveRecord::Schema.define(version: 20150323004158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "guests", force: :cascade do |t|
    t.string  "email"
    t.string  "first_name"
    t.string  "last_name"
    t.integer "invitation_id", null: false
  end

  add_index "guests", ["invitation_id"], name: "index_guests_on_invitation_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.string "email_key"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id"
    t.string  "ip_address"
    t.string  "access_token"
  end

  create_table "users", force: :cascade do |t|
    t.string  "email"
    t.string  "password_digest"
    t.string  "password_salt"
    t.integer "guest_id",                        null: false
    t.boolean "is_admin",        default: false, null: false
  end

  add_index "users", ["guest_id"], name: "index_users_on_guest_id", using: :btree

  add_foreign_key "users", "guests"
end
