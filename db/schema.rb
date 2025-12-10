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

ActiveRecord::Schema[8.1].define(version: 2025_12_10_152930) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ebook_metrics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "ebook_id", null: false
    t.string "event_type"
    t.text "extra_data"
    t.string "ip"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["ebook_id"], name: "index_ebook_metrics_on_ebook_id"
  end

  create_table "ebook_stats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "downloads_count", default: 0, null: false
    t.integer "ebook_id", null: false
    t.integer "purchases_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "views_count", default: 0, null: false
    t.index ["ebook_id"], name: "index_ebook_stats_on_ebook_id", unique: true
  end

  create_table "ebooks", force: :cascade do |t|
    t.string "author"
    t.datetime "created_at", null: false
    t.string "description"
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "seller_id", null: false
    t.string "status"
    t.string "timestamps"
    t.string "title"
    t.datetime "updated_at", null: false
    t.date "year"
    t.index ["seller_id"], name: "index_ebooks_on_seller_id"
  end

  create_table "landing_pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "published", default: false
    t.string "subtitle"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "landing_sections", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "landing_page_id", null: false
    t.string "link"
    t.integer "position", default: 0
    t.string "subtitle"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["landing_page_id"], name: "index_landing_sections_on_landing_page_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "ebook_id", null: false
    t.decimal "fee", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "order_id", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["ebook_id"], name: "index_order_items_on_ebook_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "billing_address"
    t.integer "buyer_id", null: false
    t.datetime "created_at", null: false
    t.string "destination_address"
    t.string "payment_status", default: "N/A", null: false
    t.decimal "total_fee", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_orders_on_buyer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "address"
    t.string "age"
    t.decimal "balance", precision: 10, scale: 2, default: "0.0", null: false
    t.string "country"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest"
    t.string "phone_number", null: false
    t.string "role", null: false
    t.string "status", default: "enabled", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ebook_metrics", "ebooks"
  add_foreign_key "ebooks", "users", column: "seller_id"
  add_foreign_key "landing_sections", "landing_pages"
  add_foreign_key "order_items", "ebooks"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users", column: "buyer_id"
end
