class AddDeletedAtToPageTables < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_pages_pages, :deleted_at, :timestamp
    add_column :shiny_pages_page_elements, :deleted_at, :timestamp
    add_column :shiny_pages_sections, :deleted_at, :timestamp
    add_column :shiny_pages_templates, :deleted_at, :timestamp
    add_column :shiny_pages_template_elements, :deleted_at, :timestamp
    add_index :shiny_pages_pages, :deleted_at
    add_index :shiny_pages_page_elements, :deleted_at
    add_index :shiny_pages_sections, :deleted_at
    add_index :shiny_pages_templates, :deleted_at
    add_index :shiny_pages_template_elements, :deleted_at
  end
end
