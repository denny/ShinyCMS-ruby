# Create table for page sections
class CreatePageSections < ActiveRecord::Migration[6.0]
  def change
    create_table :page_sections do |t|
      t.string :name, null: false
      t.text :description
      t.string :title, null: false
      t.string :slug, null: false
      t.integer :default_page_id
      t.integer :section_id
      t.integer :sort_order
      t.boolean :hidden, null: false, default: false
      t.datetime :last_published_at

      t.timestamps
    end
  end
end
