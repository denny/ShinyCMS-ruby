# Create table for page templates
class CreatePageTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :page_templates do |t|
      t.string :name, null: false
      t.text :description
      t.string :filename, null: false

      t.timestamps
    end
  end
end
