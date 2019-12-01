class CreatePageTemplateElements < ActiveRecord::Migration[6.0]
  def change
    create_table :page_template_elements, if_not_exists: true do |t|
      t.integer :template_id, null: false
      t.string :name, null: false
      t.string :content
      t.string :content_type, null: false, default: I18n.t( 'admin.elements.short_text' )

      t.timestamps
    end

    add_index :page_template_elements, :template_id
    add_foreign_key :page_template_elements, :page_templates, column: :template_id
  end
end
