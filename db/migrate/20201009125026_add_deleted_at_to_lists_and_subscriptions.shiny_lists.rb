# This migration comes from shiny_lists (originally 20201009124505)
class AddDeletedAtToListsAndSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_lists_lists, :deleted_at, :timestamp
    add_column :shiny_lists_subscriptions, :deleted_at, :timestamp
    add_index :shiny_lists_lists, :deleted_at
    add_index :shiny_lists_subscriptions, :deleted_at
  end
end
