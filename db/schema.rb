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

ActiveRecord::Schema.define(version: 20141012085614) do

  create_table "agencies", force: true do |t|
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packages", force: true do |t|
    t.string   "ref_number",                            null: false
    t.text     "description",                           null: false
    t.float    "weight",         limit: 24,             null: false
    t.float    "height",         limit: 24,             null: false
    t.float    "depth",          limit: 24,             null: false
    t.float    "width",          limit: 24,             null: false
    t.float    "value",          limit: 24,             null: false
    t.float    "shipping_cost",  limit: 24,             null: false
    t.integer  "status",                    default: 0
    t.integer  "agency_id"
    t.datetime "date_added"
    t.datetime "date_arrived"
    t.datetime "date_delivered"
    t.integer  "sender_id",                             null: false
    t.integer  "receiver_id",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "packages", ["agency_id"], name: "index_packages_on_agency_id", using: :btree
  add_index "packages", ["ref_number"], name: "index_packages_on_ref_number", unique: true, using: :btree

  create_table "rates", force: true do |t|
    t.float    "package",    limit: 24
    t.float    "cost",       limit: 24
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",                    null: false
    t.string   "email",                       null: false
    t.integer  "role",            default: 0
    t.integer  "agency_id"
    t.string   "oauth_token"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["agency_id"], name: "index_users_on_agency_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
