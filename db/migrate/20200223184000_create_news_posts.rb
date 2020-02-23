class CreateNewsPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :news_posts, if_not_exists: true do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body, null: false
      t.boolean :hidden, null: false, default: false
      t.integer :user_id, null: false
      t.integer :discussion_id
      t.timestamp :posted_at, null: false, default: -> { 'current_timestamp' }

      t.timestamps
    end

    add_foreign_key :news_posts, :users
    add_foreign_key :news_posts, :discussions
  end
end
