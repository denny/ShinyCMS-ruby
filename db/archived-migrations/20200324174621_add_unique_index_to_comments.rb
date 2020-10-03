class AddUniqueIndexToComments < ActiveRecord::Migration[6.0]
  def change
    add_index :comments, [:number, :discussion_id], unique: true
  end
end
