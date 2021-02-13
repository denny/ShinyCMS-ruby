# This migration comes from shiny_inserts (originally 20201009124530)
class AddDeletedAtToInsertSetsAndElements < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_inserts_sets, :deleted_at, :timestamp
    add_column :shiny_inserts_elements, :deleted_at, :timestamp
    add_index :shiny_inserts_sets, :deleted_at
    add_index :shiny_inserts_elements, :deleted_at
  end
end
