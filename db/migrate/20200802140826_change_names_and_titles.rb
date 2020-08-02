class ChangeNamesAndTitles < ActiveRecord::Migration[6.0]
  def change
    rename_column :blogs, :name,  :internal_name
    rename_column :blogs, :title, :public_name
    change_column_null :blogs, :public_name, from: false, to: true

    rename_column :pages, :name,  :internal_name
    rename_column :pages, :title, :public_name
    change_column_null :pages, :public_name, from: false, to: true

    rename_column :page_sections, :name,  :internal_name
    rename_column :page_sections, :title, :public_name
    change_column_null :page_sections, :public_name, from: false, to: true

    rename_column :mailing_lists, :name,  :internal_name
    add_column :mailing_lists, :public_name, :string
  end
end
