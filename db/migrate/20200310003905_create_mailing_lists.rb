class CreateMailingLists < ActiveRecord::Migration[6.0]
  def change
    create_table :mailing_lists do |t|
      t.string :name, null: false
      t.boolean :is_public, null: false, default: false

      t.timestamps
    end
  end
end
