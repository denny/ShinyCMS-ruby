class AddUniqueIndexForProfileProfile < ActiveRecord::Migration[8.0]
  def change
    remove_index :shiny_profiles_profiles, :user_id
    add_index :shiny_profiles_profiles, :user_id, unique: true
  end
end
