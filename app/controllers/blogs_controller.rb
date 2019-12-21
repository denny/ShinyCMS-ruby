# Main site controller for blogs (view blog, view blog post, etc)
class BlogsController < ApplicationController
  before_action :set_blog, except: :index

  def index
    @blogs = Blog.all
  end

  def recent
    @posts = @blog.recent_posts
  end

  def show
    @post = @blog.find_post( params[:year], params[:month], params[:slug] )
  end

  private

  def set_blog
    @blog =
      if Setting.get( 'Blog mode' ) == 'Multiple'
        Blog.find( params[:blog_slug] )
      else
        Blog.first
      end
  end
end
