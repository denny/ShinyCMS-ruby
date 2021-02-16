# This migration comes from shiny_forms (originally 20201009124440)
class AddDeletedAtToForms < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_forms_forms, :deleted_at, :timestamp
    add_index :shiny_forms_forms, :deleted_at
  end
end
