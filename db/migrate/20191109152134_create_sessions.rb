class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions, if_not_exists: true do |t|
      t.string :session_id, :null => false
      t.text :data

      t.timestamps
    end

    add_index :sessions, :session_id, :unique => true
    add_index :sessions, :updated_at
  end
end
