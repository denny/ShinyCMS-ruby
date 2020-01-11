class CreateInsertElements < ActiveRecord::Migration[6.0]
  def change
    create_table :insert_elements, if_not_exists: true do |t|
      t.integer :set_id, null: false
      t.string :name, null: false
      t.string :content
      t.string :content_type, null: false, default: I18n.t( 'admin.elements.short_text' )

      t.timestamps
    end

    add_index :insert_elements, :set_id
    add_foreign_key :insert_elements, :insert_sets, column: :set_id
    add_index :insert_elements, :name, unique: true
  end
end
