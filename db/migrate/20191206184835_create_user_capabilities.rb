class CreateUserCapabilities < ActiveRecord::Migration[6.0]
  def change
    create_table :user_capabilities do |t|
      t.integer :user_id, null: false
      t.integer :capability_id, null: false

      t.timestamps
    end

    add_foreign_key :user_capabilities, :users
    add_foreign_key :user_capabilities, :capabilities
  end
end
