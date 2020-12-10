class AddDeletedAtToEmailRecipient < ActiveRecord::Migration[6.0]
  def change
    add_column :email_recipients, :deleted_at, :timestamp
    add_index :email_recipients, :deleted_at
  end
end
