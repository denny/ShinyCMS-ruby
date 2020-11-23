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

      t.timestamp :began_at,   precision: 6, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :expires_at, precision: 6
      t.timestamp :ended_at,   precision: 6
      t.text :notes

      t.timestamps
      t.timestamp :deleted_at, precision: 6
    end

    add_index :shiny_access_groups, :deleted_at
    add_index :shiny_access_groups, :slug

    add_index :shiny_access_memberships, :began_at
    add_index :shiny_access_memberships, :deleted_at
    add_index :shiny_access_memberships, :ended_at
    add_index :shiny_access_memberships, :expires_at
  end
end
