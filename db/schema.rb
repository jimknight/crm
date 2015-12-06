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

ActiveRecord::Schema.define(version: 20151206004352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "client_id"
    t.datetime "activity_date"
    t.integer  "contact_id"
    t.string   "city"
    t.string   "state"
    t.string   "industry"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "attachment"
  end

  add_index "activities", ["client_id"], name: "index_activities_on_client_id", using: :btree
  add_index "activities", ["contact_id"], name: "index_activities_on_contact_id", using: :btree

  create_table "activities_models", id: false, force: true do |t|
    t.integer "activity_id", null: false
    t.integer "model_id",    null: false
  end

  create_table "appointments", force: true do |t|
    t.string   "title"
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "appointments", ["client_id"], name: "index_appointments_on_client_id", using: :btree
  add_index "appointments", ["user_id"], name: "index_appointments_on_user_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "industry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fax"
    t.string   "street3"
    t.string   "client_type"
    t.text     "status"
    t.string   "eid"
    t.text     "type"
    t.text     "source"
    t.text     "form_dump"
    t.datetime "import_datetime"
  end

  create_table "clients_users", force: true do |t|
    t.integer "client_id"
    t.integer "user_id"
  end

  add_index "clients_users", ["client_id"], name: "index_clients_users_on_client_id", using: :btree
  add_index "clients_users", ["user_id"], name: "index_clients_users_on_user_id", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "email"
    t.string   "work_phone"
    t.string   "mobile_phone"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_description"
    t.string   "work_phone_extension"
  end

  add_index "contacts", ["client_id"], name: "index_contacts_on_client_id", using: :btree

  create_table "industries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "models", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "settings", force: true do |t|
    t.text     "notify_on_new_prospect_contact"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notify_on_client_delete"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
