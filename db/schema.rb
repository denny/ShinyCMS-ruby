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

ActiveRecord::Schema.define(version: 2019_09_29_081952) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "page_sections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "title"
    t.string "slug"
    t.integer "section_id"
    t.integer "sort_order"
    t.boolean "hidden"
    t.datetime "last_published_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["section_id"], name: "index_page_sections_on_section_id"
  end

  create_table "page_templates", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "title"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "title"
    t.string "slug"
    t.integer "template_id"
    t.integer "section_id"
    t.integer "sort_order"
    t.boolean "hidden"
    t.datetime "last_published_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["section_id"], name: "index_pages_on_section_id"
    t.index ["template_id"], name: "index_pages_on_template_id"
  end

  add_foreign_key "page_sections", "page_sections", column: "section_id"
  add_foreign_key "pages", "page_sections", column: "section_id"
  add_foreign_key "pages", "page_templates", column: "template_id"
end
