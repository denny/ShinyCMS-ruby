# This migration comes from shiny_forms (originally 20250609135010)
class AddUniqueIndexForFormSlug < ActiveRecord::Migration[8.0]
  def change
    remove_index :shiny_forms_forms, :slug, if_exists: true
    add_index :shiny_forms_forms, :slug, unique: true
  end
end
