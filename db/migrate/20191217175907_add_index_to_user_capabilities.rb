class AddIndexToUserCapabilities < ActiveRecord::Migration[6.0]
  def change
    add_index :user_capabilities, [ :user_id, :capability_id ], unique: true
  end
end
