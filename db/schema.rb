# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_11_16_162428) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
    t.index ["deleted_at"], name: "index_currencies_on_deleted_at"
    t.index ["name"], name: "index_currencies_on_name", unique: true
  end

  create_table "operations", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "recipient_id", null: false
    t.bigint "currency_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "temporal_type", null: false
    t.integer "state", default: 0, null: false
    t.datetime "planned_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_operations_on_currency_id"
    t.index ["deleted_at"], name: "index_operations_on_deleted_at"
    t.index ["planned_at"], name: "index_operations_on_planned_at"
    t.index ["recipient_id"], name: "index_operations_on_recipient_id"
    t.index ["sender_id"], name: "index_operations_on_sender_id"
  end

  create_table "user_accounts", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "currency_id", null: false
    t.decimal "balance", precision: 10, scale: 2, null: false
    t.integer "status", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_user_accounts_on_currency_id"
    t.index ["deleted_at"], name: "index_user_accounts_on_deleted_at"
    t.index ["owner_id"], name: "index_user_accounts_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "role", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "operations", "currencies"
  add_foreign_key "operations", "user_accounts", column: "recipient_id"
  add_foreign_key "operations", "user_accounts", column: "sender_id"
  add_foreign_key "user_accounts", "currencies"
end
