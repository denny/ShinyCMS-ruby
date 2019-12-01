# Add indexes and foreign keys
class AddKeysToPage < ActiveRecord::Migration[6.0]
  def change
    add_index :pages, :section_id
    add_index :page_sections, :section_id

    add_foreign_key :pages, :page_templates, column: :template_id
    add_foreign_key :pages, :page_sections, column: :section_id
    add_foreign_key :page_sections, :page_sections, column: :section_id
  end
end
