class AddKeysToPageSection < ActiveRecord::Migration[6.0]
  def change
    add_index :page_sections, :section_id
    add_foreign_key :page_sections, :page_sections, column: :section_id
  end
end
