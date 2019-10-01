class FixTemplateColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :page_templates, :filename, :string

    PageTemplate.update_all( filename: 'NOT-NULL' )
    change_column_null :page_templates, :filename, false

    remove_column :page_templates, :title, :string
    remove_column :page_templates, :slug,  :string
  end
end
