class AddDeletedAtToCommentAuthor < ActiveRecord::Migration[6.0]
  def change
    add_column :comment_authors, :deleted_at, :timestamp, precision: 6
    add_index :comment_authors, :deleted_at
  end
end
