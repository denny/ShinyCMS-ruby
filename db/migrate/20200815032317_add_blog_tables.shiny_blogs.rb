# This migration comes from shiny_blogs (originally 20200815030800)
class AddBlogTables < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_blogs_blog_posts, force: :cascade do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body, null: false
      t.boolean :show_on_site, default: true, null: false
      t.bigint :blog_id, null: false
      t.bigint :user_id, null: false
      t.datetime :posted_at, default: -> { "CURRENT_TIMESTAMP" }, null: false
      t.datetime :created_at, precision: 6, null: false
      t.datetime :updated_at, precision: 6, null: false
    end

    create_table :shiny_blogs_blogs, force: :cascade do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false
      t.text :description
      t.boolean :show_in_menus, default: true, null: false
      t.boolean :show_on_site, default: true, null: false
      t.bigint :user_id, null: false
      t.datetime :created_at, precision: 6, null: false
      t.datetime :updated_at, precision: 6, null: false
    end

    add_foreign_key :shiny_blogs_blog_posts, :shiny_blogs_blogs, column: :blog_id
    add_foreign_key :shiny_blogs_blog_posts, :users
    add_foreign_key :shiny_blogs_blogs, :users
  end
end
