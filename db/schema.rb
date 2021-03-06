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

ActiveRecord::Schema.define(version: 2021_08_22_062515) do

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "store_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "store_comments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "store_id"
    t.string "title"
    t.text "introduction"
    t.string "product_image_id"
    t.float "rate"
    t.integer "genre", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.integer "user_id"
    t.string "store_name"
    t.string "menu"
    t.string "postal_code"
    t.string "address"
    t.string "transportation"
    t.string "business_day"
    t.string "holiday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.integer "business_status", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "introduction"
    t.string "profile_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
