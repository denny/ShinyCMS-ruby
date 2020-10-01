class DropUnusedForeignKeys < ActiveRecord::Migration[6.0]
  def change
    remove_column :blog_posts, :discussion_id
    remove_column :news_posts, :discussion_id
  end
end
