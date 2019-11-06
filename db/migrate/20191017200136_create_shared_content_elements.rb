class CreateSharedContentElements < ActiveRecord::Migration[6.0]
  def change
    create_table :shared_content_elements do |t|
      t.string :name, null: false
      t.string :content
      t.string :content_type, null: false, default: I18n.t( 'admin.elements.short_text' )

      t.timestamps
    end
  end
end
