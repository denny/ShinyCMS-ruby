# Admin controller for blogs (whole blogs, not individual blog posts)
class Admin::BlogsController < AdminController
  before_action :set_blog, only: %i[ edit update destroy ]
  after_action :verify_authorized

  def index
    @blogs = Blog.all
    # authorise @blogs
    skip_authorization # TODO: FIXME
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

  def edit
    authorise @blog
  end

  def update
    authorise @blog

    if @blog.update( blog_params )
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @blog.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def destroy
    authorise @blog

    flash[ :notice ] = t( '.success' ) if @blog.destroy
    redirect_to action: :index
  end

  private

  def set_blog
    @blog = Blog.find( params[:id] )
  rescue ActiveRecord::RecordNotFound
    skip_authorization
    redirect_with_alert admin_blogs_path, t( '.failure' )
  end

  def blog_params
    params.require( :blog ).permit(
      :name, :description, :title, :slug, :user_id, :hidden_from_menu, :hidden
    )
  end
end
