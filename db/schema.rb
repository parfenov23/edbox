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

ActiveRecord::Schema.define(version: 20151130054244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.integer "question_id"
    t.string  "text"
    t.boolean "right"
  end

  create_table "ask_questions", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.text     "description"
    t.boolean  "archive",             default: false
    t.boolean  "download",            default: false
    t.integer  "width"
    t.integer  "height"
    t.text     "full_text"
    t.integer  "position"
    t.boolean  "public",              default: false
  end

  create_table "bigbluebutton_room_options", force: true do |t|
    t.integer  "room_id"
    t.string   "default_layout"
    t.boolean  "presenter_share_only"
    t.boolean  "auto_start_video"
    t.boolean  "auto_start_audio"
    t.string   "background"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bigbluebutton_room_options", ["room_id"], name: "index_bigbluebutton_room_options_on_room_id", using: :btree

  create_table "bunch_attachments", force: true do |t|
    t.integer  "attachment_id"
    t.integer  "bunch_section_id"
    t.boolean  "complete",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bunch_categories", force: true do |t|
    t.integer  "course_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "categories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "first_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "paid",       default: false
  end

  create_table "courses", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "main_img"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "duration"
    t.boolean  "public",            default: false
    t.integer  "account_type_id"
    t.boolean  "paid",              default: false
    t.string   "type_course",       default: "course"
    t.datetime "announcement_date"
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
    t.boolean  "process",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date_complete"
  end

  create_table "ligament_leads", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "webinar_id"
  end

  create_table "ligament_sections", force: true do |t|
    t.integer  "section_id"
    t.datetime "date_complete"
    t.integer  "ligament_course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.integer  "user_id"
    t.integer  "attachment_id"
    t.text     "text",          default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notices", force: true do |t|
    t.string   "email"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.string   "notifytable_type"
    t.integer  "notifytable_id"
    t.boolean  "read",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "action_type"
  end

  create_table "page_questions", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "ask_question_id"
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
    t.integer  "position"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "subscriptions", force: true do |t|
    t.datetime "date_from"
    t.datetime "date_to"
    t.integer  "subscriptiontable_id"
    t.string   "subscriptiontable_type"
    t.float    "sum"
    t.boolean  "active",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_count",             default: 0
    t.text     "note"
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
    t.integer "all_questions"
    t.integer "right_answers"
  end

  create_table "tests", force: true do |t|
    t.integer "section_id"
    t.string  "title"
    t.integer "duration"
    t.integer "testable_id"
    t.string  "testable_type"
  end

  create_table "user_webinars", force: true do |t|
    t.integer  "user_id"
    t.integer  "webinar_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.boolean  "contenter",       default: false
    t.boolean  "paid",            default: false
    t.boolean  "superuser",       default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "webinars", force: true do |t|
    t.datetime "date_start"
    t.integer  "duration"
    t.integer  "attachment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event"
  end

end
