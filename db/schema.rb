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

ActiveRecord::Schema.define(version: 20151030105609) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_types", force: true do |t|
    t.string  "name"
    t.string  "title"
    t.string  "info"
    t.boolean "corporate", default: false
    t.boolean "paid",      default: false
  end

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
    t.boolean  "archive",             default: false
    t.text     "description"
    t.boolean  "download",            default: false
    t.integer  "width"
    t.integer  "height"
    t.text     "full_text"
    t.integer  "position"
    t.boolean  "public",              default: false
  end

  create_table "bigbluebutton_meetings", force: true do |t|
    t.integer  "server_id"
    t.integer  "room_id"
    t.string   "meetingid"
    t.string   "name"
    t.datetime "start_time"
    t.boolean  "running",      default: false
    t.boolean  "recorded",     default: false
    t.integer  "creator_id"
    t.string   "creator_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bigbluebutton_meetings", ["meetingid", "start_time"], name: "index_bigbluebutton_meetings_on_meetingid_and_start_time", unique: true, using: :btree

  create_table "bigbluebutton_metadata", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bigbluebutton_playback_formats", force: true do |t|
    t.integer  "recording_id"
    t.integer  "playback_type_id"
    t.string   "url"
    t.integer  "length"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bigbluebutton_playback_types", force: true do |t|
    t.string   "identifier"
    t.boolean  "visible",    default: false
    t.boolean  "default",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bigbluebutton_recordings", force: true do |t|
    t.integer  "server_id"
    t.integer  "room_id"
    t.integer  "meeting_id"
    t.string   "recordid"
    t.string   "meetingid"
    t.string   "name"
    t.boolean  "published",   default: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "available",   default: true
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bigbluebutton_recordings", ["recordid"], name: "index_bigbluebutton_recordings_on_recordid", unique: true, using: :btree
  add_index "bigbluebutton_recordings", ["room_id"], name: "index_bigbluebutton_recordings_on_room_id", using: :btree

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

  create_table "bigbluebutton_rooms", force: true do |t|
    t.integer  "server_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "meetingid"
    t.string   "name"
    t.string   "attendee_key"
    t.string   "moderator_key"
    t.string   "welcome_msg"
    t.string   "logout_url"
    t.string   "voice_bridge"
    t.string   "dial_number"
    t.integer  "max_participants"
    t.boolean  "private",                                             default: false
    t.boolean  "external",                                            default: false
    t.string   "param"
    t.boolean  "record_meeting",                                      default: false
    t.integer  "duration",                                            default: 0
    t.string   "attendee_api_password"
    t.string   "moderator_api_password"
    t.decimal  "create_time",                precision: 14, scale: 0
    t.string   "moderator_only_message"
    t.boolean  "auto_start_recording",                                default: false
    t.boolean  "allow_start_stop_recording",                          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bigbluebutton_rooms", ["meetingid"], name: "index_bigbluebutton_rooms_on_meetingid", unique: true, using: :btree
  add_index "bigbluebutton_rooms", ["server_id"], name: "index_bigbluebutton_rooms_on_server_id", using: :btree

  create_table "bigbluebutton_server_configs", force: true do |t|
    t.integer  "server_id"
    t.text     "available_layouts"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bigbluebutton_servers", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "salt"
    t.string   "version"
    t.string   "param"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "bigbluebutton_room_id"
  end

end
