class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages, if_not_exists: true do |t|
      t.string :name, null: false
      t.text :description
      t.string :title, null: false
      t.string :slug, null: false
      t.integer :template_id, null: false
      t.integer :section_id
      t.boolean :hidden, null: false, default: false

      t.timestamps
    end
  end
end
