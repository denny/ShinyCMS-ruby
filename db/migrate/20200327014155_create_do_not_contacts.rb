class CreateDoNotContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :do_not_contacts do |t|
      t.string :email

      t.timestamps
    end
    add_index :do_not_contacts, :email, unique: true
  end
end
