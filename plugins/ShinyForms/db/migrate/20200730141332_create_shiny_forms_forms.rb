class CreateShinyFormsForms < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_forms_forms do |t|
      t.string :name, null: false
      t.string :internal_name
      t.string :slug, null: false
      t.text :description
      t.boolean :show_on_site, null: false, default: true
      t.boolean :show_in_menu, null: false, default: true
      t.boolean :show_on_sitemap, null: false, default: true
      t.integer :sort_order
      t.references :template, null: false, foreign_key: { to_table: :shiny_forms_templates }

      t.timestamps
    end
  end
end
