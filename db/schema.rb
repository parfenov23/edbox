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

ActiveRecord::Schema.define(version: 20170324080427) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "card_first_six"
    t.string   "card_last_four"
    t.string   "card_type"
    t.string   "issuer_bank_country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ads", force: true do |t|
    t.string   "type_ad"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "href"
    t.string   "img"
    t.boolean  "active"
    t.integer  "time_line",  default: 0
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
    t.text     "description"
    t.boolean  "archive",             default: false
    t.boolean  "download",            default: false
    t.integer  "width"
    t.integer  "height"
    t.text     "full_text"
    t.integer  "position"
    t.boolean  "public",              default: false
    t.text     "embed_video"
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

  create_table "billing_coupons", force: true do |t|
    t.string   "title"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "billing_prices", force: true do |t|
    t.float    "company_price",      default: 1.0
    t.float    "user_price",         default: 1.0
    t.float    "company_user_price", default: 1.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "test_user_price",    default: 0.0
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

  create_table "card_categories", force: true do |t|
    t.string   "title"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "card_items", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "card_id"
    t.integer  "card_category_id"
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
    t.string   "phone"
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
    t.text     "og"
    t.boolean  "archive",           default: false
    t.string   "download_url"
    t.string   "redirect_url"
  end

  create_table "deliveries", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "users_id",    default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_notifs", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_courses", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_webinars", force: true do |t|
    t.integer  "webinar_id"
    t.integer  "group_id"
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

  create_table "incoming_moneys", force: true do |t|
    t.integer  "user_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_notifications", force: true do |t|
    t.integer  "invoice_id"
    t.text     "pay_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_notifications", ["invoice_id"], name: "index_invoice_notifications_on_invoice_id", using: :btree

  create_table "invoices", force: true do |t|
    t.integer  "payment_id"
    t.float    "amount",     default: 0.0
    t.datetime "paid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["payment_id"], name: "index_invoices_on_payment_id", using: :btree

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

  create_table "news", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "users_id",    default: [], array: true
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

  create_table "oggs", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.string   "oggtable_type"
    t.integer  "oggtable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_questions", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "ask_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.float    "amount",                 default: 0.0
    t.float    "real_amount"
    t.string   "gateway_code"
    t.string   "gateway_payment_method"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phrasing_phrases", force: true do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
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
    t.float    "sum",                    default: 0.0
    t.boolean  "active",                 default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_count",             default: 0
    t.text     "note"
    t.string   "type_order"
  end

  create_table "tags", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tagtable_type"
    t.integer  "tagtable_id"
  end

  create_table "tariff_infos", force: true do |t|
    t.string   "title"
    t.string   "array_ids"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariffs", force: true do |t|
    t.string   "title"
    t.string   "type_tariff"
    t.boolean  "active"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teasers", force: true do |t|
    t.integer  "attachment_id"
    t.integer  "course_id"
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
    t.integer  "participant_id"
    t.datetime "date_entry"
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
    t.text     "social"
    t.boolean  "help",            default: true
    t.string   "kid_name"
    t.string   "kid_class"
    t.boolean  "active",          default: false
    t.string   "city"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "webinar_logs", force: true do |t|
    t.string   "type_send"
    t.string   "params"
    t.string   "path"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "webinars", force: true do |t|
    t.datetime "date_start"
    t.integer  "duration"
    t.integer  "attachment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event"
    t.string   "status"
    t.integer  "video_id"
    t.string   "url"
    t.string   "jid"
    t.integer  "session"
  end

end
