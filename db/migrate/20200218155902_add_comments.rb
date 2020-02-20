class AddComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments, if_not_exists: true do |t|
      t.integer :discussion_id, null: false
      t.integer :number, null: false
      t.integer :parent_id
      t.string :author_type
      t.integer :author_id
      t.string :author_name
      t.string :author_email
      t.string :author_url
      t.string :title
      t.text :body
      t.boolean :locked, null: false, default: false
      t.boolean :hidden, null: false, default: false
      t.boolean :spam, null: false, default: false
      t.timestamp :posted_at, null: false, default: -> { 'current_timestamp' }

      t.timestamps
    end

    add_foreign_key :comments, :discussions, column: :discussion_id
    add_foreign_key :comments, :comments, column: :parent_id
  end
end
