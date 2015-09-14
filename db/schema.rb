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

ActiveRecord::Schema.define(version: 20150914095049) do

  create_table "clients", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "key",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "clients", ["key"], name: "index_clients_on_key"
  add_index "clients", ["name"], name: "index_clients_on_name"

  create_table "transactions", force: :cascade do |t|
    t.integer  "debtor_id",                null: false
    t.integer  "creditor_id",              null: false
    t.integer  "issuer_id",                null: false
    t.string   "issuer_type",              null: false
    t.integer  "amount",       default: 0, null: false
    t.string   "message"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "id_at_client"
  end

  add_index "transactions", ["creditor_id"], name: "index_transactions_on_creditor_id"
  add_index "transactions", ["debtor_id"], name: "index_transactions_on_debtor_id"
  add_index "transactions", ["issuer_id", "id_at_client"], name: "index_transactions_on_issuer_id_and_id_at_client"
  add_index "transactions", ["issuer_type", "issuer_id"], name: "index_transactions_on_issuer_type_and_issuer_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "balance",    default: 0,     null: false
    t.boolean  "penning",    default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "users", ["balance"], name: "index_users_on_balance"
  add_index "users", ["name"], name: "index_users_on_name"

end
