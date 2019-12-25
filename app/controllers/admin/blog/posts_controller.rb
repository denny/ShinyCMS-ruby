# Admin controller for blog posts
class Admin::Blog::PostsController < AdminController
  before_action :set_blog
  before_action :set_blog_post, only: %i[ edit update delete ]
  after_action :verify_authorized

  def index
    page_num = params[ :page ] || 1
    @posts = @blog.all_posts.order( :created_at ).page( page_num )
    # authorise @posts
    skip_authorization  # TODO: whyyyyyy?
  end

  def new
    @post = @blog.posts.new
    authorise @post
  end

  def create
    @post = @blog.posts.new( new_blog_post_params )
    authorise @post

    if @post.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @post.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit; end

  def update
    if @post.update( blog_post_params )
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @post.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def delete
    if @post.destroy
      flash[ :notice ] = t( '.success' )
    else
      flash[ :alert ] = t( '.failure' )
    end
    redirect_to admin_blog_posts_path
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
  end

  def set_blog_post
    @post = @blog.posts.find( params[:id] )
    authorise @post
  end

  def new_blog_post_params
    unless current_user.can? :change_author, :blog_posts
      params[ :blog_post ][ :user_id ] = current_user.id
    end

    params.require( :blog_post ).permit(
      :blog_id, :user_id, :title, :slug, :posted_at, :body, :hidden
    )
  end

  def blog_post_params
    unless current_user.can? :change_author, :blog_posts
      params[ :blog_post ][ :user_id ].delete
    end

    params.require( :blog_post ).permit(
      :blog_id, :user_id, :title, :slug, :posted_at, :body, :hidden
    )
  end
end
