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

ActiveRecord::Schema.define(version: 20150715084546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.integer "question_id"
    t.string  "text"
    t.boolean "right"
  end

  create_table "attachments", force: true do |t|
    t.string   "file"
    t.string   "file_type"
    t.string   "attachmentable_type"
    t.integer  "attachmentable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "size"
    t.text     "title"
    t.integer  "duration",            default: 0
  end

  create_table "bunch_courses", force: true do |t|
    t.integer  "course_id"
    t.integer  "group_id"
    t.datetime "date_start"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "archive",            default: false
    t.string   "model_type"
    t.integer  "user_id"
    t.boolean  "complete",           default: false
    t.integer  "ligament_course_id"
    t.datetime "date_complete"
  end

  create_table "bunch_groups", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bunch_sections", force: true do |t|
    t.datetime "date_complete"
    t.boolean  "complete",        default: false
    t.integer  "section_id"
    t.integer  "bunch_course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bunch_tags", force: true do |t|
    t.integer  "course_id"
    t.integer  "tag_id"
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
    t.integer  "user_id"
    t.integer  "duration"
  end

  create_table "favorite_courses", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "first_name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "ligament_courses", force: true do |t|
    t.integer  "course_id"
    t.integer  "group_id"
    t.boolean  "process",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.integer "test_id"
    t.string  "title"
  end

  create_table "sections", force: true do |t|
    t.string   "title"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_results", force: true do |t|
    t.integer "user_id"
    t.integer "test_id"
    t.integer "result"
  end

  create_table "tests", force: true do |t|
    t.integer "section_id"
    t.string  "title"
  end

  create_table "users", force: true do |t|
    t.string   "email",           default: "",             null: false
    t.string   "password_digest", default: "",             null: false
    t.string   "user_key",        default: "",             null: false
    t.string   "first_name",      default: "Пользователь"
    t.string   "last_name",       default: "Пользователь"
    t.text     "avatar",          default: ""
    t.string   "job",             default: "Должность"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.boolean  "director",        default: false
    t.boolean  "corporate",       default: false
    t.integer  "group_id"
    t.datetime "last_auth"
    t.boolean  "leading",         default: false
    t.text     "about_me"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
