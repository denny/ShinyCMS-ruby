class AddDeletedAtToNewsPost < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_news_posts, :deleted_at, :timestamp, precision: 6
    add_index :shiny_news_posts, :deleted_at
  end
end
