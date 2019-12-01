# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_09_152134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "page_elements", force: :cascade do |t|
    t.integer "page_id", null: false
    t.string "name", null: false
    t.string "content"
    t.string "content_type", default: "Short Text", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["page_id"], name: "index_page_elements_on_page_id"
  end

  create_table "page_sections", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "title", null: false
    t.string "slug", null: false
    t.integer "default_page_id"
    t.integer "section_id"
    t.integer "sort_order"
    t.boolean "hidden_from_menu", default: false, null: false
    t.boolean "hidden", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["section_id"], name: "index_page_sections_on_section_id"
    t.index ["slug", "section_id"], name: "index_page_sections_on_slug_and_section_id", unique: true
  end

  create_table "page_template_elements", force: :cascade do |t|
    t.integer "template_id", null: false
    t.string "name", null: false
    t.string "content"
    t.string "content_type", default: "Short Text", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["template_id"], name: "index_page_template_elements_on_template_id"
  end

  create_table "page_templates", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "filename", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "title", null: false
    t.string "slug", null: false
    t.integer "template_id", null: false
    t.integer "section_id"
    t.integer "sort_order"
    t.boolean "hidden_from_menu", default: false, null: false
    t.boolean "hidden", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["section_id"], name: "index_pages_on_section_id"
    t.index ["slug", "section_id"], name: "index_pages_on_slug_and_section_id", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name", null: false
    t.string "value"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shared_content_elements", force: :cascade do |t|
    t.string "name", null: false
    t.string "content"
    t.string "content_type", default: "Short Text", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "display_name"
    t.string "display_email"
    t.string "profile_pic"
    t.text "bio"
    t.string "website"
    t.string "location"
    t.string "postcode"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "page_elements", "pages"
  add_foreign_key "page_sections", "page_sections", column: "section_id"
  add_foreign_key "page_template_elements", "page_templates", column: "template_id"
  add_foreign_key "pages", "page_sections", column: "section_id"
  add_foreign_key "pages", "page_templates", column: "template_id"
end
