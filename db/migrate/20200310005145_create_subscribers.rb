class CreateSubscribers < ActiveRecord::Migration[6.0]
  def change
    create_table :subscribers do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.uuid :token, null: false

      t.timestamps
    end
  end
end
