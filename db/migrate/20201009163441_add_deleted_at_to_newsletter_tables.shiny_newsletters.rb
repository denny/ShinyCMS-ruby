# This migration comes from shiny_newsletters (originally 20201009162923)
class AddDeletedAtToNewsletterTables < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_newsletters_editions, :deleted_at, :timestamp, precision: 6
    add_column :shiny_newsletters_edition_elements, :deleted_at, :timestamp, precision: 6
    add_column :shiny_newsletters_sends, :deleted_at, :timestamp, precision: 6
    add_column :shiny_newsletters_templates, :deleted_at, :timestamp, precision: 6
    add_column :shiny_newsletters_template_elements, :deleted_at, :timestamp, precision: 6
    add_index :shiny_newsletters_editions, :deleted_at
    add_index :shiny_newsletters_edition_elements, :deleted_at
    add_index :shiny_newsletters_sends, :deleted_at
    add_index :shiny_newsletters_templates, :deleted_at
    add_index :shiny_newsletters_template_elements, :deleted_at
  end
end
