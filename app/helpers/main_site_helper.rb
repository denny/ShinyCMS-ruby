# Methods that might be useful in templates on the main site
module MainSiteHelper
  def current_user_can?( capability, category = :general )
    current_user&.can? capability, category
  end

  def shared_content( name )
    SharedContentElement.where( name: name ).pick( :content )
  end

  def user_display_name( user = current_user )
    user.display_name.presence || user.username
  end

  def view_blog_post_path( post )
    if Blog.multiple_blogs_mode
      # :nocov:
      "/blog/#{post.blog.slug}/#{post.year}/#{post.month}/#{post.slug}"
      # :nocov:
    else
      "/blog/#{post.year}/#{post.month}/#{post.slug}"
    end
  end
end
