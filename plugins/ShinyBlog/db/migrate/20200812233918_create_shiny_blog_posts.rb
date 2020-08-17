class CreateShinyBlogPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_blog_posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body
      t.boolean :show_on_site, null: false, default: true
      t.references :user
      t.datetime :posted_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_foreign_key 'shiny_blog_posts', 'users'
  end
end
