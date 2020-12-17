class AddDeletedAtToDiscussion < ActiveRecord::Migration[6.0]
  def change
    add_column :discussions, :deleted_at, :timestamp
    add_index :discussions, :deleted_at
  end
end
