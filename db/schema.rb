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

ActiveRecord::Schema.define(version: 20150626114140) do

  create_table "attachments", force: true do |t|
    t.string   "file"
    t.string   "file_type"
    t.string   "attachmentable_type"
    t.integer  "attachmentable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bunch_courses", force: true do |t|
    t.integer  "course_id"
    t.integer  "group_id"
    t.datetime "date_start"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",    default: false
  end

  create_table "bunch_groups", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "main_img"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "first_name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string   "title"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",           default: "",             null: false
    t.string   "password_digest", default: "",             null: false
    t.string   "user_key",        default: "",             null: false
    t.string   "first_name",      default: "Пользователь"
    t.string   "last_name",       default: "Пользователь"
    t.string   "avatar",          default: ""
    t.string   "job",             default: "Должность"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.boolean  "director",        default: false
    t.boolean  "corporate",       default: false
    t.integer  "group_id"
    t.datetime "last_auth"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
