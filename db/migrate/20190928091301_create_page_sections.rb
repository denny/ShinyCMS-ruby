class CreatePageSections < ActiveRecord::Migration[6.0]
  def change
    create_table :page_sections do |t|
      t.string :name
      t.text :description
      t.string :title
      t.string :slug
      t.integer :section_id
      t.integer :sort_order
      t.boolean :hidden
      t.datetime :last_published_at

      t.timestamps
    end
  end
end
