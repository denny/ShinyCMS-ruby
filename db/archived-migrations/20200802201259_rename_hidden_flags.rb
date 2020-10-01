class RenameHiddenFlags < ActiveRecord::Migration[6.0]
  def change
    rename_column :blog_posts, :hidden, :show_on_site
    change_column_default :blog_posts, :show_on_site, from: false, to: true
    t = BlogPost.where( show_on_site: true  )
    f = BlogPost.where( show_on_site: false )
    t.update( show_on_site: false )
    f.update( show_on_site: true  )

    rename_column :blogs, :hidden, :show_on_site
    change_column_default :blogs, :show_on_site, from: false, to: true
    t = Blog.where( show_on_site: true  )
    f = Blog.where( show_on_site: false )
    t.update( show_on_site: false )
    f.update( show_on_site: true  )

    rename_column :blogs, :hidden_from_menu, :show_in_menus
    change_column_default :blogs, :show_in_menus, from: false, to: true
    t = Blog.where( show_in_menus: true  )
    f = Blog.where( show_in_menus: false )
    t.update( show_on_site: false )
    f.update( show_on_site: true  )

    rename_column :comments, :hidden, :show_on_site
    change_column_default :comments, :show_on_site, from: false, to: true
    t = Comment.where( show_on_site: true  )
    f = Comment.where( show_on_site: false )
    t.update( show_on_site: false )
    f.update( show_on_site: true  )

    rename_column :discussions, :hidden, :show_on_site
    change_column_default :discussions, :show_on_site, from: false, to: true
    t = Discussion.where( show_on_site: true  )
    f = Discussion.where( show_on_site: false )
    t.update( show_on_site: false )
    f.update( show_on_site: true  )

    rename_column :news_posts, :hidden, :show_on_site
    change_column_default :news_posts, :show_on_site, from: false, to: true
    t = NewsPost.where( show_on_site: true  )
    f = NewsPost.where( show_on_site: false )
    t.update( show_on_site: false )
    f.update( show_on_site: true  )

    rename_column :pages, :hidden, :show_on_site
    change_column_default :pages, :show_on_site, from: false, to: true
    t = Page.where( show_on_site: true  )
    f = Page.where( show_on_site: false )
    t.update( show_on_site: false )
    f.update( show_on_site: true  )

    rename_column :pages, :hidden_from_menu, :show_in_menus
    change_column_default :pages, :show_in_menus, from: false, to: true
    t = Page.where( show_in_menus: true  )
    f = Page.where( show_in_menus: false )
    t.update( show_on_site: false )
    f.update( show_on_site: true  )

    rename_column :page_sections, :hidden, :show_on_site
    change_column_default :page_sections, :show_on_site, from: false, to: true
    t = PageSection.where( show_on_site: true  )
    f = PageSection.where( show_on_site: false )
    t.update( show_on_site: false )
    f.update( show_on_site: true  )

    rename_column :page_sections, :hidden_from_menu, :show_in_menus
    change_column_default :page_sections, :show_in_menus, from: false, to: true
    t = PageSection.where( show_in_menus: true  )
    f = PageSection.where( show_in_menus: false )
    t.update( show_on_site: false )
    f.update( show_on_site: true  )
  end
end
