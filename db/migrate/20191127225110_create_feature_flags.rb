class CreateFeatureFlags < ActiveRecord::Migration[6.0]
  def change
    create_table :feature_flags do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :enabled, null: false, default: false
      t.boolean :enabled_for_logged_in, null: false, default: false
      t.boolean :enabled_for_admins, null: false, default: false

      t.timestamps
    end

    add_index :feature_flags, :name, unique: true
  end
end
