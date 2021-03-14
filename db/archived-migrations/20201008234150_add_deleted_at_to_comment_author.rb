class AddDeletedAtToCommentAuthor < ActiveRecord::Migration[6.0]
  def change
    add_column :comment_authors, :deleted_at, :timestamp
    add_index :comment_authors, :deleted_at
  end
end
