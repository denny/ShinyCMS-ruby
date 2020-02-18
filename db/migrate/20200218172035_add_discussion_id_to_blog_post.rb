class AddDiscussionIdToBlogPost < ActiveRecord::Migration[6.0]
  def change
    add_column :blog_posts, :discussion_id, :integer
  end
end
