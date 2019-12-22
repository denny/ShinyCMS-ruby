# Admin controller for blogs (whole blogs, not individual blog posts)
class Admin::BlogsController < AdminController
  before_action :set_blog, only: %i[ edit update delete ]
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
      redirect_to action: :edit, id: @blog.id, notice: t( '.created' )
    else
      flash.now[ :alert ] = t( '.create_failed' )
      render action: :new
    end
  end

  def edit; end

  def update
    if @blog.update( blog_params )
      redirect_to action: :edit, id: @blog.id, notice: t( '.updated' )
    else
      flash.now[ :alert ] = t( '.update_failed' )
      render action: :edit
    end
  end

  def delete
    if @blog.destroy
      redirect_to admin_blogs_path, notice: t( '.deleted')
    else
      redirect_to admin_blogs_path, alert: t( '.delete_failed' )
    end
  end

  private

  def set_blog
    @blog =
      if Blog.multiple_blogs_mode
        Blog.find( params[:id] )
      else
        Blog.all.first
      end
    authorise @blog
  end

  def blog_params
    params.require( :blog ).permit(
      :name, :description, :title, :slug, :hidden_from_menu, :hidden
    )
  end
end
