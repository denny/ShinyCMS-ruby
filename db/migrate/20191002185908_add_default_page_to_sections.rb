class AddDefaultPageToSections < ActiveRecord::Migration[6.0]
  def change
    add_column :page_sections, :default_page_id, :integer
  end
end
