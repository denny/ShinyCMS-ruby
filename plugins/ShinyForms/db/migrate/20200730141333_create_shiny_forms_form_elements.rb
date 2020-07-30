class CreateShinyFormsFormElements < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_forms_form_elements do |t|
      t.string :name, null: false
      t.string :element_type, null: false
      t.text :content
      t.references :form, null: false, foreign_key: { to_table: :shiny_forms_forms }

      t.timestamps
    end
  end
end
