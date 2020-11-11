# This migration comes from shiny_access (originally 20201111033231)
class CreateShinyAccessTables < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_access_groups do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false
      t.text :description

      t.timestamps
    end

    create_table :shiny_access_memberships do |t|
      t.references :group, references: :shiny_access_groups, foreign_key: { to_table: :shiny_access_groups }, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamp :began_at, null: false
      t.timestamp :ended_at

      t.timestamps
    end
  end
end
