class CreatePageTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :page_templates do |t|
      t.string :name
      t.text :description
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
