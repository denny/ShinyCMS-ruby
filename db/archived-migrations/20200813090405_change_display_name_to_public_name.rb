class ChangeDisplayNameToPublicName < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :display_name,  :public_name
    rename_column :users, :display_email, :public_email
  end
end
