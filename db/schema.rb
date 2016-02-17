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

ActiveRecord::Schema.define(version: 20151220173008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.integer  "client_id"
    t.datetime "activity_date"
    t.integer  "contact_id"
    t.string   "city",          limit: 255
    t.string   "state",         limit: 255
    t.string   "industry",      limit: 255
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "attachment",    limit: 255
  end

  add_index "activities", ["client_id"], name: "index_activities_on_client_id", using: :btree
  add_index "activities", ["contact_id"], name: "index_activities_on_contact_id", using: :btree

  create_table "activities_models", id: false, force: :cascade do |t|
    t.integer "activity_id", null: false
    t.integer "model_id",    null: false
  end

  create_table "appointments", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "contact_id"
  end

  add_index "appointments", ["client_id"], name: "index_appointments_on_client_id", using: :btree
  add_index "appointments", ["contact_id"], name: "index_appointments_on_contact_id", using: :btree
  add_index "appointments", ["user_id"], name: "index_appointments_on_user_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "street1",         limit: 255
    t.string   "street2",         limit: 255
    t.string   "city",            limit: 255
    t.string   "state",           limit: 255
    t.string   "zip",             limit: 255
    t.string   "phone",           limit: 255
    t.string   "industry",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fax",             limit: 255
    t.string   "street3",         limit: 255
    t.string   "client_type",     limit: 255
    t.text     "status"
    t.string   "eid",             limit: 255
    t.text     "prospect_type"
    t.text     "source"
    t.text     "form_dump"
    t.datetime "import_datetime"
    t.text     "comments"
    t.string   "country",         limit: 255
  end

  create_table "clients_outsiders", id: false, force: :cascade do |t|
    t.integer "client_id",   null: false
    t.integer "outsider_id", null: false
  end

  add_index "clients_outsiders", ["client_id", "outsider_id"], name: "index_clients_outsiders_on_client_id_and_outsider_id", using: :btree
  add_index "clients_outsiders", ["outsider_id", "client_id"], name: "index_clients_outsiders_on_outsider_id_and_client_id", using: :btree

  create_table "clients_users", force: :cascade do |t|
    t.integer "client_id"
    t.integer "user_id"
  end

  add_index "clients_users", ["client_id"], name: "index_clients_users_on_client_id", using: :btree
  add_index "clients_users", ["user_id"], name: "index_clients_users_on_user_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "title",                limit: 255
    t.string   "email",                limit: 255
    t.string   "work_phone",           limit: 255
    t.string   "mobile_phone",         limit: 255
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_description",  limit: 255
    t.string   "work_phone_extension", limit: 255
    t.text     "comments"
  end

  add_index "contacts", ["client_id"], name: "index_contacts_on_client_id", using: :btree

  create_table "industries", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "models", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "outsiders", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.text     "notify_on_new_prospect_contact"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notify_on_client_delete"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                              default: false
    t.string   "role",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
