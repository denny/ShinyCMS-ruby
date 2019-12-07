class CreateCapabilityCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :capability_categories do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
