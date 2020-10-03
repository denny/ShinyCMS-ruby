class AddCanonicalEmailToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :canonical_email, :string
  end
end
