class AddTablesForShinyPages < ActiveRecord::Migration[6.0]
  def change
    create_table "shiny_pages_templates", force: :cascade do |t|
      t.string "name", null: false
      t.text "description"
      t.string "filename", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
    end

    create_table "shiny_pages_template_elements", force: :cascade do |t|
      t.bigint "template_id", null: false
      t.string "name", null: false
      t.string "content"
      t.string "element_type", default: "Short Text", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["template_id"], name: "index_page_template_elements_on_template_id"
    end

    create_table "shiny_pages_sections", force: :cascade do |t|
      t.string "internal_name", null: false
      t.string "public_name"
      t.string "slug", null: false
      t.text "description"
      t.bigint "default_page_id"
      t.bigint "section_id"
      t.integer "sort_order"
      t.boolean "show_in_menus", default: true, null: false
      t.boolean "show_on_site", default: true, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["section_id"], name: "index_page_sections_on_section_id"
      t.index ["slug", "section_id"], name: "index_page_sections_on_slug_and_section_id", unique: true
    end

    create_table "shiny_pages_pages", force: :cascade do |t|
      t.string "internal_name", null: false
      t.string "public_name"
      t.string "slug", null: false
      t.text "description"
      t.bigint "template_id", null: false
      t.bigint "section_id"
      t.integer "sort_order"
      t.boolean "show_in_menus", default: true, null: false
      t.boolean "show_on_site", default: true, null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["section_id"], name: "index_pages_on_section_id"
      t.index ["slug", "section_id"], name: "index_pages_on_slug_and_section_id", unique: true
    end

    create_table "shiny_pages_page_elements", force: :cascade do |t|
      t.bigint "page_id", null: false
      t.string "name", null: false
      t.string "content"
      t.string "element_type", default: "Short Text", null: false
      t.datetime "created_at", precision: 6, null: false
      t.datetime "updated_at", precision: 6, null: false
      t.index ["page_id"], name: "index_page_elements_on_page_id"
    end

    add_foreign_key :shiny_pages_pages,             :shiny_pages_templates, column: :template_id
    add_foreign_key :shiny_pages_pages,             :shiny_pages_sections,  column: :section_id
    add_foreign_key :shiny_pages_sections,          :shiny_pages_sections,  column: :section_id
    add_foreign_key :shiny_pages_template_elements, :shiny_pages_templates, column: :template_id
    add_foreign_key :shiny_pages_page_elements,     :shiny_pages_pages,     column: :page_id
  end
end
