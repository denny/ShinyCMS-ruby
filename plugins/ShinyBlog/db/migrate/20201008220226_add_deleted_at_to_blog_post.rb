class AddDeletedAtToBlogPost < ActiveRecord::Migration[6.0]
  def change
    add_column :shiny_blog_posts, :deleted_at, :timestamp
    add_index :shiny_blog_posts, :deleted_at
  end
end
