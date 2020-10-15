class AddDeletedAtToDoNotContact < ActiveRecord::Migration[6.0]
  def change
    add_column :do_not_contacts, :deleted_at, :timestamp, precision: 6
    add_index :do_not_contacts, :deleted_at
  end
end
