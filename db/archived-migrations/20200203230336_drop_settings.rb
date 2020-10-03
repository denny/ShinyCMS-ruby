class DropSettings < ActiveRecord::Migration[6.0]
  def change
    drop_table :settings, if_exists: true
  end
end
