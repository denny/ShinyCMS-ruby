class CreateShinyAccessGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_access_groups do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false
      t.text :description

      t.timestamps
    end
  end
end
