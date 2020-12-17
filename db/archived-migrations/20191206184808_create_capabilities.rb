class CreateCapabilities < ActiveRecord::Migration[6.0]
  def change
    create_table :capabilities do |t|
      t.string :name, null: false
      t.integer :category_id
      t.string :description

      t.timestamps
    end

    add_foreign_key :capabilities, :capability_categories, column: :category_id
  end
end
