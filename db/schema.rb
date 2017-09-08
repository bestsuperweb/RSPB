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

ActiveRecord::Schema.define(version: 20170907152219) do

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.decimal  "usd"
    t.decimal  "gbp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quotations", force: :cascade do |t|
    t.integer  "customer_id",            limit: 8
    t.text     "message"
    t.integer  "quantity"
    t.integer  "yearly_quantity_id"
    t.boolean  "resize_image"
    t.string   "image_width"
    t.string   "image_height"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.string   "product_variant_ids"
    t.text     "message_for_production"
    t.string   "status",                                                   default: "new"
    t.integer  "created_by_user_id",     limit: 8
    t.integer  "modified_by_user_id",    limit: 8
    t.string   "token",                                                    default: " "
    t.boolean  "set_margin"
    t.string   "return_file_format"
    t.text     "additional_comment"
    t.string   "customer_name"
    t.string   "customer_email"
    t.text     "product_variants"
    t.decimal  "total_price",                      precision: 8, scale: 2
    t.index ["customer_id"], name: "index_quotations_on_customer_id"
    t.index ["yearly_quantity_id"], name: "index_quotations_on_yearly_quantity_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", null: false
    t.string   "shopify_token",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "templates", force: :cascade do |t|
    t.integer  "customer_id",            limit: 8
    t.integer  "order_id",               limit: 8
    t.string   "template_name"
    t.text     "message"
    t.string   "product_variant_ids"
    t.string   "return_file_format"
    t.boolean  "set_margin",                       default: false
    t.boolean  "resize_image",                     default: false
    t.integer  "image_width"
    t.integer  "image_height"
    t.text     "message_for_production"
    t.text     "additional_comment"
    t.integer  "times_used"
    t.datetime "last_used_at"
    t.boolean  "disabled",                         default: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "quotation_id"
    t.text     "product_variants"
    t.index ["quotation_id"], name: "index_templates_on_quotation_id"
  end

  create_table "turnarounds", force: :cascade do |t|
    t.string   "name"
    t.string   "handle"
    t.decimal  "multiplier"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "available_at_price"
    t.index ["handle"], name: "index_turnarounds_on_handle", unique: true
    t.index ["name"], name: "index_turnarounds_on_name", unique: true
  end

  create_table "volume_discounts", force: :cascade do |t|
    t.string   "name"
    t.string   "handle"
    t.decimal  "multiplier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["handle"], name: "index_volume_discounts_on_handle", unique: true
    t.index ["name"], name: "index_volume_discounts_on_name", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.integer  "customer_id",         limit: 8
    t.integer  "order_id",            limit: 8
    t.integer  "refund_id",           limit: 8
    t.string   "transection_type"
    t.string   "payment_method"
    t.string   "currency"
    t.decimal  "subtotal",                      precision: 8, scale: 2
    t.decimal  "tax",                           precision: 8, scale: 2
    t.decimal  "total",                         precision: 8, scale: 2
    t.decimal  "wallet_balance",                precision: 8, scale: 2
    t.boolean  "test",                                                  default: false
    t.boolean  "cancelled",                                             default: false
    t.text     "note"
    t.integer  "created_by_user_id",  limit: 8
    t.integer  "modified_by_user_id", limit: 8
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.integer  "draft_order_id",      limit: 8
  end

  create_table "yearly_quantities", force: :cascade do |t|
    t.string   "yearly_quantity_label"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

end
