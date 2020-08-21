# This migration comes from shiny_inserts (originally 20200820224612)
class AddShinyInsertsTables < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_inserts_sets, force: :cascade do |t|
      t.datetime :created_at, precision: 6, null: false
      t.datetime :updated_at, precision: 6, null: false
    end

    create_table :shiny_inserts_elements, force: :cascade do |t|
      t.string :name, null: false
      t.string :content
      t.string :element_type, default: "Short Text", null: false
      t.bigint :set_id, null: false
      t.datetime :created_at, precision: 6, null: false
      t.datetime :updated_at, precision: 6, null: false
      t.index ["name"], name: :index_insert_elements_on_name, unique: true
      t.index ["set_id"], name: :index_insert_elements_on_set_id
    end

    add_foreign_key :shiny_inserts_elements, :shiny_inserts_sets, column: :set_id
  end
end
