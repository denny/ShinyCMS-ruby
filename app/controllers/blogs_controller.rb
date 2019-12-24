# Main site controller for blogs (view blog, view blog post, etc)
class BlogsController < ApplicationController
  before_action :check_feature_flags
  before_action :set_blog, except: :index

  def index
    # :nocov:
    @blogs = Blog.all
    # :nocov:
  end

  def recent
    page_num = params[:page] || 1
    @posts = @blog.recent_posts.page( page_num )
  end

  def show
    @post = @blog.find_post( params[:year], params[:month], params[:slug] )
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
  end

  def check_feature_flags
    enforce_feature_flags :blogs
  end
end
