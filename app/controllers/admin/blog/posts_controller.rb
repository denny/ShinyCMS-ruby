# Admin controller for blog posts
class Admin::Blog::PostsController < AdminController
  before_action :set_blog
  before_action :set_blog_post, only: %i[ edit update delete ]
  after_action :verify_authorized

  def index
    page_num = params[ :page ] || 1
    @posts = @blog.all_posts.order( :created_at ).page( page_num )
    authorise @posts
  end

  def new
    @post = @blog.posts.new
    authorise @post
  end

  def create
    params = blog_post_params
    params[ :user_id ] = current_user.id

    @post = @blog.posts.new( params )
    authorise @post

    if @post.save
      redirect_to action: :edit, id: @post.id, notice: t( '.created' )
    else
      flash.now[ :alert ] = t( '.create_failed' )
      render action: :new
    end
  end

  def edit; end

  def update
    params = blog_post_params
    unless current_user.can? :change_author, :blog_posts
      params.delete( :user_id )
    end

    if @post.update( params )
      redirect_to action: :edit, id: @post.id, notice: t( '.updated' )
    else
      flash.now[ :alert ] = t( '.update_failed' )
      render action: :edit
    end
  end

  def delete
    if @post.destroy
      redirect_to admin_blog_posts_path, notice: t( '.deleted')
    else
      redirect_to admin_blog_posts_path, alert: t( '.delete_failed' )
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
  end

  def set_blog_post
    @post = @blog.posts.find( params[:id] )
    authorise @post
  end

  def blog_post_params
    params.require( :blog_post ).permit(
      :blog_id, :user_id, :title, :slug, :body, :hidden
    )
  end
end
