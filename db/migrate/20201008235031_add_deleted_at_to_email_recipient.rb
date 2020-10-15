class AddDeletedAtToEmailRecipient < ActiveRecord::Migration[6.0]
  def change
    add_column :email_recipients, :deleted_at, :timestamp, precision: 6
    add_index :email_recipients, :deleted_at
  end
end
