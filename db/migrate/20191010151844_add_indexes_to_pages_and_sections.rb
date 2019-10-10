class AddIndexesToPagesAndSections < ActiveRecord::Migration[6.0]
  def change
    add_index :pages, [ :slug, :section_id ], unique: true
    add_index :page_sections, [ :slug, :section_id ], unique: true
  end
end
