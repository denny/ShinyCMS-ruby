class CreatePageElements < ActiveRecord::Migration[6.0]
  def change
    create_table :page_elements, if_not_exists: true do |t|
      t.integer :page_id, null: false
      t.string :name, null: false
      t.string :content
      t.string :content_type, null: false, default: I18n.t( 'admin.elements.short_text' )

      t.timestamps
    end

    add_index :page_elements, :page_id
    add_foreign_key :page_elements, :pages, column: :page_id
  end
end
