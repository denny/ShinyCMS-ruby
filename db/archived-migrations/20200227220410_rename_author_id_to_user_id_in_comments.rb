class RenameAuthorIdToUserIdInComments < ActiveRecord::Migration[6.0]
  def change
    rename_column :comments, :author_id, :user_id
  end
end
