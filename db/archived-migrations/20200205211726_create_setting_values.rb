class CreateSettingValues < ActiveRecord::Migration[6.0]
  def change
    create_table :setting_values do |t|
      t.integer :setting_id, null: false
      t.integer :user_id
      t.string :value

      t.timestamps
    end

    add_foreign_key :setting_values, :settings, column: :setting_id
    add_foreign_key :setting_values, :users,    column: :user_id
  end
end
