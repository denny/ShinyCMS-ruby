class CreateBlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :blogs, if_not_exists: true do |t|
      t.string :name, null: false
      t.text :description
      t.string :title, null: false
      t.string :slug, null: false
      t.boolean :hidden_from_menu, null: false, default: false
      t.boolean :hidden, null: false, default: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_foreign_key :blogs, :users
  end
end
