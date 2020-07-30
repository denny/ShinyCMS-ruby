class CreateShinyFormsTemplateElements < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_forms_template_elements do |t|
      t.string :name, null: false
      t.string :element_type, null: false
      t.text :content
      t.references :template, null: false, foreign_key: { to_table: :shiny_forms_templates }

      t.timestamps
    end
  end
end
