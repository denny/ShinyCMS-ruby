class CreateShinyFormsTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_forms_templates do |t|
      t.string :name, null: false
      t.text :description
      t.string :filename, null: false

      t.timestamps
    end
  end
end
