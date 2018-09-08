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

ActiveRecord::Schema.define(version: 20160527091320) do

  create_table "adverts", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "link"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.string   "name"
    t.integer  "author_id"
    t.integer  "position",            default: 100
    t.integer  "data_type",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "attachments", ["author_id"], name: "index_attachments_on_author_id", using: :btree

  create_table "call_back_bills", force: true do |t|
    t.integer  "order_id"
    t.float    "cash_fee",          limit: 24
    t.string   "out_trade_no"
    t.string   "transaction_id"
    t.integer  "order_place_in_id"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "call_back_bills", ["order_id"], name: "index_call_back_bills_on_order_id", using: :btree
  add_index "call_back_bills", ["order_place_in_id"], name: "index_call_back_bills_on_order_place_in_id", using: :btree

  create_table "cancel_order_details", force: true do |t|
    t.integer  "cancel_order_id"
    t.integer  "shop_commodity_id"
    t.integer  "commodity_id"
    t.float    "price",             limit: 24
    t.integer  "count"
    t.float    "total_amount",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cancel_order_details", ["cancel_order_id"], name: "index_cancel_order_details_on_cancel_order_id", using: :btree
  add_index "cancel_order_details", ["commodity_id"], name: "index_cancel_order_details_on_commodity_id", using: :btree
  add_index "cancel_order_details", ["shop_commodity_id"], name: "index_cancel_order_details_on_shop_commodity_id", using: :btree

  create_table "cancel_orders", force: true do |t|
    t.integer  "order_id"
    t.integer  "shop_id"
    t.integer  "user_id"
    t.float    "total_amount", limit: 24
    t.string   "receipt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cancel_orders", ["order_id"], name: "index_cancel_orders_on_order_id", using: :btree
  add_index "cancel_orders", ["shop_id"], name: "index_cancel_orders_on_shop_id", using: :btree
  add_index "cancel_orders", ["user_id"], name: "index_cancel_orders_on_user_id", using: :btree

  create_table "classifications", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "position",          default: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "single_statistics"
  end

  add_index "classifications", ["parent_id"], name: "index_classifications_on_parent_id", using: :btree

  create_table "code_tables", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "position",      default: 100
    t.string   "remark"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "default_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "code_tables", ["parent_id"], name: "index_code_tables_on_parent_id", using: :btree

  create_table "commodities", force: true do |t|
    t.string   "name"
    t.string   "summary"
    t.string   "content"
    t.string   "identifier"
    t.float    "reference_price",   limit: 24
    t.integer  "cover_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "classification_id"
    t.boolean  "is_fictitious",                default: false
    t.boolean  "show_content",                 default: false
  end

  add_index "commodities", ["cover_id"], name: "index_commodities_on_cover_id", using: :btree

  create_table "communities", force: true do |t|
    t.string   "name"
    t.integer  "kind"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "communities", ["region_id"], name: "index_communities_on_region_id", using: :btree

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "member_number"
    t.string   "phone"
    t.string   "email"
    t.float    "score",         limit: 24, default: 0.0
    t.string   "weixin_id"
    t.integer  "lase_shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["lase_shop_id"], name: "index_customers_on_lase_shop_id", using: :btree

  create_table "dummy_shop_orders", force: true do |t|
    t.integer  "order_id"
    t.string   "user_name"
    t.string   "user_phone"
    t.string   "commodity_name"
    t.string   "commodity_num"
    t.boolean  "is_fund",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dummy_shop_orders", ["order_id"], name: "index_dummy_shop_orders_on_order_id", using: :btree

  create_table "employees", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "employees", ["shop_id"], name: "index_employees_on_shop_id", using: :btree

  create_table "express_orders", force: true do |t|
    t.string   "consignee"
    t.string   "phone"
    t.string   "address"
    t.integer  "status"
    t.integer  "shop_id"
    t.integer  "courier_id"
    t.text     "serial_number"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "express_orders", ["shop_id"], name: "index_express_orders_on_shop_id", using: :btree

  create_table "notices", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "author"
    t.datetime "public_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_comments", force: true do |t|
    t.integer  "order_id"
    t.integer  "shop_id"
    t.float    "total_star",  limit: 24
    t.float    "speed_star",  limit: 24
    t.float    "serve_start", limit: 24
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_comments", ["order_id"], name: "index_order_comments_on_order_id", using: :btree
  add_index "order_comments", ["shop_id"], name: "index_order_comments_on_shop_id", using: :btree

  create_table "order_details", force: true do |t|
    t.integer  "order_id"
    t.integer  "shop_commodity_id"
    t.integer  "commodity_id"
    t.float    "price",             limit: 24
    t.integer  "count"
    t.float    "total_amount",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_details", ["commodity_id"], name: "index_order_details_on_commodity_id", using: :btree
  add_index "order_details", ["order_id"], name: "index_order_details_on_order_id", using: :btree
  add_index "order_details", ["shop_commodity_id"], name: "index_order_details_on_shop_commodity_id", using: :btree

  create_table "order_expresses", force: true do |t|
    t.integer  "order_id"
    t.string   "address"
    t.string   "phone"
    t.string   "name"
    t.integer  "user_id"
    t.boolean  "is_express_now",     default: true
    t.datetime "express_start_time"
    t.datetime "express_end_time"
    t.datetime "complete_date"
    t.boolean  "is_ontime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_expresses", ["order_id"], name: "index_order_expresses_on_order_id", using: :btree
  add_index "order_expresses", ["user_id"], name: "index_order_expresses_on_user_id", using: :btree

  create_table "order_logs", force: true do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.integer  "status"
    t.text     "content"
    t.boolean  "is_system"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_logs", ["order_id"], name: "index_order_logs_on_order_id", using: :btree
  add_index "order_logs", ["user_id"], name: "index_order_logs_on_user_id", using: :btree

  create_table "order_payments", force: true do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.integer  "pay_type"
    t.float    "money",      limit: 24
    t.boolean  "is_success"
    t.datetime "pay_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_payments", ["order_id"], name: "index_order_payments_on_order_id", using: :btree
  add_index "order_payments", ["user_id"], name: "index_order_payments_on_user_id", using: :btree

  create_table "order_place_ins", force: true do |t|
    t.integer  "order_id"
    t.string   "out_trade_no"
    t.float    "cash_fee",     limit: 24
    t.integer  "status"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "customer_id"
    t.integer  "shop_id"
    t.datetime "payed_at"
    t.float    "total_amount",                limit: 24, default: 0.0
    t.float    "commodity_amount",            limit: 24, default: 0.0
    t.float    "consume_score",               limit: 24, default: 0.0
    t.float    "consume_amount",              limit: 24, default: 0.0
    t.float    "actual_amount",               limit: 24, default: 0.0
    t.string   "actual_reason"
    t.integer  "status"
    t.datetime "complete_date"
    t.datetime "set_out_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "express_amount",              limit: 24
    t.integer  "pay_style"
    t.float    "material_commodity_amount",   limit: 24, default: 0.0
    t.float    "fictitious_commodity_amount", limit: 24, default: 0.0
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree
  add_index "orders", ["shop_id"], name: "index_orders_on_shop_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "position",   default: 100
    t.string   "remark"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["parent_id"], name: "index_organizations_on_parent_id", using: :btree

  create_table "permissions", force: true do |t|
    t.string   "action"
    t.string   "subject"
    t.string   "description"
    t.string   "code"
    t.integer  "group_id"
    t.string   "fetching"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["group_id"], name: "index_permissions_on_group_id", using: :btree

  create_table "receiving_addresses", force: true do |t|
    t.integer  "customer_id"
    t.string   "address"
    t.string   "phone"
    t.string   "name"
    t.boolean  "is_default"
    t.integer  "community_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  add_index "receiving_addresses", ["community_id"], name: "index_receiving_addresses_on_community_id", using: :btree
  add_index "receiving_addresses", ["customer_id"], name: "index_receiving_addresses_on_customer_id", using: :btree
  add_index "receiving_addresses", ["shop_id"], name: "index_receiving_addresses_on_shop_id", using: :btree

  create_table "role_permissions", force: true do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_permissions", ["permission_id"], name: "index_role_permissions_on_permission_id", using: :btree
  add_index "role_permissions", ["role_id"], name: "index_role_permissions_on_role_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position",    default: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "score_records", force: true do |t|
    t.integer  "customer_id"
    t.boolean  "is_plus"
    t.integer  "relation_id"
    t.string   "relation_id_type"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "score_records", ["customer_id"], name: "index_score_records_on_customer_id", using: :btree

  create_table "shop_commodities", force: true do |t|
    t.integer  "shop_id"
    t.integer  "commodity_id"
    t.float    "price",        limit: 24
    t.integer  "position",                default: 100
    t.boolean  "enable",                  default: true
    t.integer  "sales_volume",            default: 0
    t.date     "delete_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "left_count",              default: 0
    t.boolean  "is_has_long",             default: false
  end

  add_index "shop_commodities", ["commodity_id"], name: "index_shop_commodities_on_commodity_id", using: :btree
  add_index "shop_commodities", ["shop_id"], name: "index_shop_commodities_on_shop_id", using: :btree

  create_table "shop_manage_users", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "map_location"
    t.integer  "region_id"
    t.integer  "parent_id"
    t.boolean  "can_express",                       default: true
    t.float    "express_amount",         limit: 24, default: 0.0
    t.time     "can_express_start_date",            default: '2000-01-01 00:00:00'
    t.time     "can_express_end_date",              default: '2000-01-01 23:59:59'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["parent_id"], name: "index_shops_on_parent_id", using: :btree
  add_index "shops", ["region_id"], name: "index_shops_on_region_id", using: :btree

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "remark"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "shop_manage_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
