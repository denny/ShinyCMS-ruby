# This migration comes from shiny_profiles (originally 20201128224232)
class CreateShinyProfilesTables < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_profiles_profiles do |t|
      t.string :public_name
      t.string :public_email
      t.text :bio
      t.string :location
      t.string :postcode

      t.boolean :show_on_site, null: false, default: true
      t.boolean :show_in_gallery, null: false, default: true
      t.boolean :show_to_unauthenticated, null: false, default: true

      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
      t.datetime :deleted_at, index: true
    end

    create_table :shiny_profiles_links do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.integer :position

      t.belongs_to :profile, foreign_key: { to_table: :shiny_profiles_profiles }, null: false

      t.timestamps
      t.datetime :deleted_at, index: true
    end
  end
end
