class RenameContentTypeColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :page_elements, :content_type, :element_type
    rename_column :page_template_elements, :content_type, :element_type
    rename_column :insert_elements, :content_type, :element_type
  end
end
