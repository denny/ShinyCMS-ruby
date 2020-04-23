# frozen_string_literal: true

# Methods that might be useful in templates on the main site
module MainSiteHelper
  include ActsAsTaggableOn::TagsHelper

  def current_user_can?( capability, category = :general )
    current_user&.can? capability, category
  end

  def current_user_is_admin?
    current_user&.admin?
  end

  def current_user_is_not_admin?
    !current_user_is_admin?
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
    return if user.blank?

    user.display_name_or_username
  end

  def user_profile_link( user = current_user )
    link_to user_display_name( user ), user_profile_path( user.username )
  end

  # Returns the path to a comment's parent resource, anchored to the comment
  # Tries to fall back gracefully if comment is deleted/marked as spam
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def comment_in_context_path( comment )
    num =
      if comment.blank? || comment.spam?
        'comments'
      else
        comment.number
      end
    if comment.discussion.resource_type == 'BlogPost'
      view_blog_post_path( comment.discussion.resource ) + "##{num}"
    elsif comment.discussion.resource_type == 'NewsPost'
      view_news_post_path( comment.discussion.resource ) + "##{num}"
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def view_blog_post_path( post )
    if Blog.multiple_blogs_mode?
      # :nocov:
      blog_slug = post.blog.slug
      "/blog/#{blog_slug}/#{post.posted_year}/#{post.posted_month}/#{post.slug}"
      # :nocov:
    else
      "/blog/#{post.posted_year}/#{post.posted_month}/#{post.slug}"
    end
  end

  def view_news_post_path( post )
    "/news/#{post.posted_year}/#{post.posted_month}/#{post.slug}"
  end
end
