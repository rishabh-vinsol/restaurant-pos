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

ActiveRecord::Schema[7.0].define(version: 2023_06_05_100418) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "pincode"
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.boolean "default"
    t.time "opening_time"
    t.time "closing_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "branches_meals", force: :cascade do |t|
    t.bigint "branch_id"
    t.bigint "meal_id"
    t.boolean "active"
    t.boolean "available"
    t.index ["branch_id"], name: "index_branches_meals_on_branch_id"
    t.index ["meal_id"], name: "index_branches_meals_on_meal_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.integer "price_per_portion"
    t.boolean "non_veg"
    t.boolean "extra_request"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients_meals", force: :cascade do |t|
    t.bigint "meal_id"
    t.bigint "ingredient_id"
    t.integer "ingredient_quantity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_ingredients_meals_on_ingredient_id"
    t.index ["meal_id", "ingredient_id"], name: "index_ingredients_meals_on_meal_id_and_ingredient_id", unique: true
    t.index ["meal_id"], name: "index_ingredients_meals_on_meal_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "quantity", default: 0
    t.bigint "branch_id", null: false
    t.bigint "ingredient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_inventories_on_branch_id"
    t.index ["ingredient_id", "branch_id"], name: "index_inventories_on_ingredient_id_and_branch_id", unique: true
    t.index ["ingredient_id"], name: "index_inventories_on_ingredient_id"
  end

  create_table "meals", force: :cascade do |t|
    t.string "name"
    t.integer "price", default: 0
    t.boolean "active"
    t.boolean "non_veg", default: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "status"
    t.bigint "user_id", null: false
    t.bigint "branch_id", null: false
    t.integer "total"
    t.string "contact_number"
    t.datetime "placed_on"
    t.datetime "pickup_time"
    t.datetime "picked_up_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_orders_on_branch_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "user_id", null: false
    t.integer "status"
    t.integer "mode"
    t.string "stripe_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "auth_token"
    t.string "reset_token"
    t.datetime "verified_at", precision: nil
    t.bigint "branch_id"
    t.index ["branch_id"], name: "index_users_on_branch_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "inventories", "branches"
  add_foreign_key "inventories", "ingredients"
  add_foreign_key "orders", "branches"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "payments", "users"
  add_foreign_key "users", "branches"
end
