class AddUniqueIndexToSettingValues < ActiveRecord::Migration[6.0]
  def change
    add_index :setting_values, [:setting_id, :user_id], unique: true
  end
end
