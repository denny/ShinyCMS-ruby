# Admin controller for blogs (whole blogs, not individual blog posts)
class Admin::BlogsController < AdminController
  before_action :set_blog, only: %i[ edit update destroy ]
  after_action :verify_authorized

  def index
    @blogs = Blog.all
    authorise @blogs
  end

  def new
    @blog = Blog.new
    authorise @blog
  end

  def create
    @blog = Blog.new( blog_params )
    authorise @blog

    if @blog.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @blog.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit; end

  def update
    if @blog.update( blog_params )
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @blog.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def destroy
    if @blog.destroy
      flash[ :notice ] = t( '.success' )
    else
      flash[ :alert ] = t( '.failure' )
    end
    redirect_to admin_blogs_path
  end

  private

  def set_blog
    @blog =
      if Blog.multiple_blogs_mode
        # :nocov:
        Blog.find( params[:id] )
        # :nocov:
      else
        Blog.all.first
      end
    authorise @blog
  end

  def blog_params
    params.require( :blog ).permit(
      :name, :description, :title, :slug, :user_id, :hidden_from_menu, :hidden
    )
  end
end
