class AddDeletedAtToInsertSetsAndElements < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_inserts_sets, :deleted_at, :timestamp, precision: 6
    add_column :shiny_inserts_elements, :deleted_at, :timestamp, precision: 6
    add_index :shiny_inserts_sets, :deleted_at
    add_index :shiny_inserts_elements, :deleted_at
  end
end
