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

ActiveRecord::Schema.define(version: 2019_05_08_192738) do

  create_table "android_device_registration_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_android_device_registration_tokens_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_clients_on_key"
    t.index ["name"], name: "index_clients_on_name"
  end

  create_table "clients_roles", id: false, force: :cascade do |t|
    t.integer "client_id"
    t.integer "role_id"
    t.index ["client_id", "role_id"], name: "index_clients_roles_on_client_id_and_role_id"
    t.index ["client_id"], name: "index_clients_roles_on_client_id"
    t.index ["role_id"], name: "index_clients_roles_on_role_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "message"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "debtor_id", null: false
    t.integer "creditor_id", null: false
    t.string "issuer_type", null: false
    t.integer "issuer_id", null: false
    t.integer "amount", default: 0, null: false
    t.string "message"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creditor_id"], name: "index_requests_on_creditor_id"
    t.index ["debtor_id"], name: "index_requests_on_debtor_id"
    t.index ["issuer_type", "issuer_id"], name: "index_requests_on_issuer_type_and_issuer_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "debtor_id", null: false
    t.integer "creditor_id", null: false
    t.string "issuer_type", null: false
    t.integer "issuer_id", null: false
    t.integer "amount", default: 0, null: false
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "id_at_client"
    t.index ["creditor_id"], name: "index_transactions_on_creditor_id"
    t.index ["debtor_id"], name: "index_transactions_on_debtor_id"
    t.index ["issuer_id", "id_at_client"], name: "index_transactions_on_issuer_id_and_id_at_client"
    t.index ["issuer_type", "issuer_id"], name: "index_transactions_on_issuer_type_and_issuer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "balance", default: 0, null: false
    t.boolean "penning", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key"
    t.index ["balance"], name: "index_users_on_balance"
    t.index ["name"], name: "index_users_on_name"
  end

end
