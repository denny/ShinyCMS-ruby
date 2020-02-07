# Methods that might be useful in templates on the main site
module MainSiteHelper
  include ActsAsTaggableOn::TagsHelper

  def current_user_can?( capability, category = :general )
    current_user&.can? capability, category
  end

  def insert( name )
    InsertSet.first.elements.where( name: name ).pick( :content )
  end

  def insert_type?( name, type )
    InsertSet.first.elements.where( name: name ).pick( :content_type ) == type
  end

  def setting( name )
    Setting.get( name, current_user )
  end

  def user_display_name( user = current_user )
    user.display_name.presence || user.username
  end

  def user_profile_link( user = current_user )
    link_to user_display_name( user ), user_profile_path( user.username )
  end

  def view_blog_post_path( post )
    if Blog.multiple_blogs_mode
      # :nocov:
      blog_slug = post.blog.slug
      "/blog/#{blog_slug}/#{post.posted_year}/#{post.posted_month}/#{post.slug}"
      # :nocov:
    else
      "/blog/#{post.posted_year}/#{post.posted_month}/#{post.slug}"
    end
  end
end
