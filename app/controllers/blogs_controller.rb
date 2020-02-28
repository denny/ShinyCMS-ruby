# Main site controller for blogs (view blog, view blog post, etc)
class BlogsController < ApplicationController
  before_action :check_feature_flags
  before_action :set_blog, except: :index
  before_action :stash_recaptcha_keys, only: %i[ show ]

  def index
    # :nocov:
    @blogs = Blog.all
    # :nocov:
  end

  def recent
    page_num = params[:page] || 1
    @posts = @blog.recent_posts.page( page_num )
  end

  def month
    @posts = @blog.posts_for_month( params[:year], params[:month] )
  end

  def year
    @posts = @blog.posts_for_year( params[:year] )
  end

  def show
    @post = @blog.find_post( params[:year], params[:month], params[:slug] )
    return if @post.present?

    @resource_type = 'Blog post'
    render 'errors/404', status: :not_found
  end

  private

  def set_blog
    @blog =
      if Blog.multiple_blogs_mode
        # :nocov:
        Blog.find( params[:blog_slug] )
        # :nocov:
      else
        Blog.first
      end
    return if @blog.present?

    flash[ :alert ] = t( 'blogs.set_blog.failure' )
    redirect_to root_path
  end

  def stash_recaptcha_keys
    @recaptcha_v3_key = ENV[ 'RECAPTCHA_V3_SITE_KEY' ]
    @recaptcha_v2_key = ENV[ 'RECAPTCHA_V2_SITE_KEY' ]
  end

  def check_feature_flags
    enforce_feature_flags :blogs
  end
end
