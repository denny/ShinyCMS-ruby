class CreateBlogPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :blog_posts, if_not_exists: true do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body, null: false
      t.boolean :hidden, null: false, default: false
      t.integer :blog_id, null: false
      t.integer :user_id, null: false
      t.timestamp :posted_at, null: false, default: -> { 'current_timestamp' }

      t.timestamps
    end

    add_foreign_key :blog_posts, :blogs
    add_foreign_key :blog_posts, :users
  end
end
