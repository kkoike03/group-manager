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

ActiveRecord::Schema.define(version: 20160810212640) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "assign_rental_items", force: :cascade do |t|
    t.integer  "rental_order_id",  null: false
    t.integer  "rentable_item_id", null: false
    t.integer  "num",              null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "assign_rental_items", ["rentable_item_id"], name: "index_assign_rental_items_on_rentable_item_id", using: :btree
  add_index "assign_rental_items", ["rental_order_id"], name: "index_assign_rental_items_on_rental_order_id", using: :btree

  create_table "assign_stages", force: :cascade do |t|
    t.integer  "stage_order_id"
    t.integer  "stage_id"
    t.string   "time_point_start"
    t.string   "time_point_end"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "assign_stages", ["stage_id"], name: "index_assign_stages_on_stage_id", using: :btree
  add_index "assign_stages", ["stage_order_id"], name: "index_assign_stages_on_stage_order_id", using: :btree

  create_table "config_user_permissions", force: :cascade do |t|
    t.string   "form_name",                     null: false
    t.boolean  "is_accepting",  default: false
    t.boolean  "is_only_show",  default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "panel_partial",                 null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name_ja"
    t.string   "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_categories", force: :cascade do |t|
    t.string   "name_ja"
    t.string   "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "name",                 null: false
    t.integer  "student_id",           null: false
    t.integer  "employee_category_id"
    t.boolean  "duplication"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "employees", ["employee_category_id"], name: "index_employees_on_employee_category_id", using: :btree
  add_index "employees", ["group_id"], name: "index_employees_on_group_id", using: :btree

  create_table "fes_dates", force: :cascade do |t|
    t.integer  "days_num"
    t.string   "date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "day",         null: false
    t.integer  "fes_year_id"
  end

  add_index "fes_dates", ["fes_year_id"], name: "index_fes_dates_on_fes_year_id", using: :btree

  create_table "fes_years", force: :cascade do |t|
    t.integer  "fes_year",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "food_products", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "name",                       null: false
    t.integer  "first_day_num",  default: 0, null: false
    t.boolean  "is_cooking",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "second_day_num", default: 0
  end

  add_index "food_products", ["group_id"], name: "index_food_products_on_group_id", using: :btree

  create_table "grades", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_categories", force: :cascade do |t|
    t.string   "name_ja"
    t.string   "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_manager_common_options", force: :cascade do |t|
    t.string   "cooking_start_time"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "date_of_stool_test"
  end

  create_table "group_project_names", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "project_name", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "group_project_names", ["group_id"], name: "index_group_project_names_on_group_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",              null: false
    t.integer  "group_category_id"
    t.integer  "user_id"
    t.text     "activity"
    t.text     "first_question"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "fes_year_id"
  end

  add_index "groups", ["fes_year_id"], name: "index_groups_on_fes_year_id", using: :btree
  add_index "groups", ["group_category_id"], name: "index_groups_on_group_category_id", using: :btree
  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "place_allow_lists", force: :cascade do |t|
    t.integer  "place_id",                          null: false
    t.integer  "group_category_id",                 null: false
    t.boolean  "enable",            default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "place_allow_lists", ["group_category_id"], name: "index_place_allow_lists_on_group_category_id", using: :btree
  add_index "place_allow_lists", ["place_id", "group_category_id"], name: "index_place_allow_lists_on_place_id_and_group_category_id", unique: true, using: :btree
  add_index "place_allow_lists", ["place_id"], name: "index_place_allow_lists_on_place_id", using: :btree

  create_table "place_orders", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "first"
    t.integer  "second"
    t.integer  "third"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "place_orders", ["group_id"], name: "index_place_orders_on_group_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name_ja"
    t.string   "name_en"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "power_orders", force: :cascade do |t|
    t.integer  "group_id",     null: false
    t.string   "item",         null: false
    t.integer  "power"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "manufacturer", null: false
    t.string   "model",        null: false
  end

  add_index "power_orders", ["group_id"], name: "index_power_orders_on_group_id", using: :btree

  create_table "purchase_lists", force: :cascade do |t|
    t.integer  "food_product_id", null: false
    t.integer  "shop_id",         null: false
    t.integer  "fes_date_id",     null: false
    t.boolean  "is_fresh"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "items",           null: false
  end

  add_index "purchase_lists", ["fes_date_id"], name: "index_purchase_lists_on_fes_date_id", using: :btree
  add_index "purchase_lists", ["food_product_id"], name: "index_purchase_lists_on_food_product_id", using: :btree
  add_index "purchase_lists", ["shop_id"], name: "index_purchase_lists_on_shop_id", using: :btree

  create_table "rentable_items", force: :cascade do |t|
    t.integer  "stocker_item_id"
    t.integer  "stocker_place_id"
    t.integer  "max_num",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "rentable_items", ["stocker_item_id"], name: "index_rentable_items_on_stocker_item_id", using: :btree
  add_index "rentable_items", ["stocker_place_id"], name: "index_rentable_items_on_stocker_place_id", using: :btree

  create_table "rental_item_allow_lists", force: :cascade do |t|
    t.integer  "rental_item_id"
    t.integer  "group_category_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "rental_item_allow_lists", ["group_category_id"], name: "index_rental_item_allow_lists_on_group_category_id", using: :btree
  add_index "rental_item_allow_lists", ["rental_item_id", "group_category_id"], name: "index_rental_item_allow_unique", unique: true, using: :btree
  add_index "rental_item_allow_lists", ["rental_item_id"], name: "index_rental_item_allow_lists_on_rental_item_id", using: :btree

  create_table "rental_items", force: :cascade do |t|
    t.string   "name_ja",                    null: false
    t.string   "name_en"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_rentable", default: true, null: false
  end

  create_table "rental_orders", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "rental_item_id"
    t.integer  "num"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "rental_orders", ["group_id"], name: "index_rental_orders_on_group_id", using: :btree
  add_index "rental_orders", ["rental_item_id"], name: "index_rental_orders_on_rental_item_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "name",                              null: false
    t.string   "tel",                               null: false
    t.string   "time_weekdays"
    t.string   "time_sat"
    t.string   "time_sun"
    t.string   "time_holidays"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "kana"
    t.boolean  "is_closed_sun",     default: false
    t.boolean  "is_closed_mon",     default: false
    t.boolean  "is_closed_tue",     default: false
    t.boolean  "is_closed_wed",     default: false
    t.boolean  "is_closed_thu",     default: false
    t.boolean  "is_closed_fri",     default: false
    t.boolean  "is_closed_sat",     default: false
    t.boolean  "is_closed_holiday", default: false
  end

  create_table "stage_common_options", force: :cascade do |t|
    t.integer  "group_id",          null: false
    t.boolean  "own_equipment"
    t.boolean  "bgm"
    t.boolean  "camera_permittion"
    t.boolean  "loud_sound"
    t.text     "stage_content",     null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "stage_common_options", ["group_id"], name: "index_stage_common_options_on_group_id", using: :btree

  create_table "stage_orders", force: :cascade do |t|
    t.integer  "group_id"
    t.boolean  "is_sunny"
    t.integer  "fes_date_id"
    t.integer  "stage_first"
    t.integer  "stage_second"
    t.string   "time_interval"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "time_point_start"
    t.string   "time_point_end"
  end

  add_index "stage_orders", ["fes_date_id"], name: "index_stage_orders_on_fes_date_id", using: :btree
  add_index "stage_orders", ["group_id"], name: "index_stage_orders_on_group_id", using: :btree

  create_table "stages", force: :cascade do |t|
    t.string   "name_ja",                      null: false
    t.string   "name_en"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "enable_sunny", default: false
    t.boolean  "enable_rainy", default: false
  end

  create_table "stocker_items", force: :cascade do |t|
    t.integer  "rental_item_id"
    t.integer  "stocker_place_id"
    t.integer  "num",              null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "fes_year_id"
  end

  add_index "stocker_items", ["fes_year_id"], name: "index_stocker_items_on_fes_year_id", using: :btree
  add_index "stocker_items", ["rental_item_id"], name: "index_stocker_items_on_rental_item_id", using: :btree
  add_index "stocker_items", ["stocker_place_id"], name: "index_stocker_items_on_stocker_place_id", using: :btree

  create_table "stocker_places", force: :cascade do |t|
    t.string   "name",                                null: false
    t.boolean  "is_available_fesdate", default: true, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "sub_reps", force: :cascade do |t|
    t.integer  "group_id",      null: false
    t.string   "name_ja",       null: false
    t.string   "name_en",       null: false
    t.integer  "department_id", null: false
    t.integer  "grade_id",      null: false
    t.string   "tel",           null: false
    t.string   "email",         null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "sub_reps", ["department_id"], name: "index_sub_reps_on_department_id", using: :btree
  add_index "sub_reps", ["grade_id"], name: "index_sub_reps_on_grade_id", using: :btree
  add_index "sub_reps", ["group_id"], name: "index_sub_reps_on_group_id", using: :btree

  create_table "user_details", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name_ja"
    t.string   "name_en"
    t.integer  "department_id"
    t.integer  "grade_id"
    t.string   "tel"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_details", ["department_id"], name: "index_user_details_on_department_id", using: :btree
  add_index "user_details", ["grade_id"], name: "index_user_details_on_grade_id", using: :btree
  add_index "user_details", ["user_id"], name: "index_user_details_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_detail_id"
    t.boolean  "get_notice",             default: false, null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["user_detail_id"], name: "index_users_on_user_detail_id", using: :btree

  add_foreign_key "assign_rental_items", "rentable_items"
  add_foreign_key "assign_rental_items", "rental_orders"
  add_foreign_key "assign_stages", "stage_orders"
  add_foreign_key "assign_stages", "stages"
  add_foreign_key "employees", "employee_categories"
  add_foreign_key "employees", "groups"
  add_foreign_key "fes_dates", "fes_years"
  add_foreign_key "food_products", "groups"
  add_foreign_key "group_project_names", "groups"
  add_foreign_key "groups", "fes_years"
  add_foreign_key "groups", "group_categories"
  add_foreign_key "groups", "users"
  add_foreign_key "place_allow_lists", "group_categories"
  add_foreign_key "place_allow_lists", "places"
  add_foreign_key "place_orders", "groups"
  add_foreign_key "power_orders", "groups"
  add_foreign_key "purchase_lists", "fes_dates"
  add_foreign_key "purchase_lists", "food_products"
  add_foreign_key "purchase_lists", "shops"
  add_foreign_key "rentable_items", "stocker_items"
  add_foreign_key "rentable_items", "stocker_places"
  add_foreign_key "rental_item_allow_lists", "group_categories"
  add_foreign_key "rental_item_allow_lists", "rental_items"
  add_foreign_key "rental_orders", "groups"
  add_foreign_key "rental_orders", "rental_items"
  add_foreign_key "stage_common_options", "groups"
  add_foreign_key "stage_orders", "fes_dates"
  add_foreign_key "stage_orders", "groups"
  add_foreign_key "stocker_items", "fes_years"
  add_foreign_key "stocker_items", "rental_items"
  add_foreign_key "stocker_items", "stocker_places"
  add_foreign_key "sub_reps", "departments"
  add_foreign_key "sub_reps", "grades"
  add_foreign_key "sub_reps", "groups"
  add_foreign_key "user_details", "departments"
  add_foreign_key "user_details", "grades"
  add_foreign_key "user_details", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "user_details"
end
