class AddDeletedAtToListsAndSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_lists_lists, :deleted_at, :timestamp, precision: 6
    add_column :shiny_lists_subscriptions, :deleted_at, :timestamp, precision: 6
    add_index :shiny_lists_lists, :deleted_at
    add_index :shiny_lists_subscriptions, :deleted_at
  end
end
