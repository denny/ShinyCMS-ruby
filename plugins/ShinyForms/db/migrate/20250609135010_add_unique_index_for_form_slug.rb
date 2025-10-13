class AddUniqueIndexForFormSlug < ActiveRecord::Migration[8.0]
  def change
    remove_index :shiny_forms_forms, :slug, if_exists: true
    add_index :shiny_forms_forms, :slug, unique: true
  end
end
