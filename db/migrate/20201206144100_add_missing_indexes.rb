class AddMissingIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :capabilities, :category_id
    add_index :comments,     :parent_id

    add_index :shiny_pages_sections, :default_page_id
  end
end
