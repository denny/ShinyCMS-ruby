class AddDeletedAtToForms < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_forms_forms, :deleted_at, :timestamp, precision: 6
    add_index :shiny_forms_forms, :deleted_at
  end
end
