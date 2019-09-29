class NotNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :pages,          :name,   false, default = 'A page'
    change_column_null :page_sections,  :name,   false, default = 'A section'
    change_column_null :page_templates, :name,   false, default = 'A template'

    change_column_null :pages,          :title,  false, default = 'A Page'
    change_column_null :page_sections,  :title,  false, default = 'A Section'
    change_column_null :page_templates, :title,  false, default = 'A Template'

    change_column_null :pages,          :slug,   false, default = 'a-page'
    change_column_null :page_sections,  :slug,   false, default = 'a-section'
    change_column_null :page_templates, :slug,   false, default = 'a-template'

    change_column_null    :pages,         :hidden, false, default = false
    change_column_null    :page_sections, :hidden, false, default = false

    change_column_default :pages,         :hidden, from: nil, to: false
    change_column_default :page_sections, :hidden, from: nil, to: false

    tid = PageTemplate.first.id
    change_column_null :pages, :template_id, false, default = tid
  end
end
