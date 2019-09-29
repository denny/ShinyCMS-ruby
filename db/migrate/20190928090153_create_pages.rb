class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.string :name
      t.text :description
      t.string :title
      t.string :slug
      t.integer :template_id
      t.integer :section_id
      t.integer :sort_order
      t.boolean :hidden
      t.datetime :last_published_at

      t.timestamps
    end
  end
end
