class CreateFeatureFlags < ActiveRecord::Migration[6.0]
  def change
    create_table :feature_flags do |t|
      t.string :name
      t.string :state
      t.text :description

      t.timestamps
    end
  end
end
