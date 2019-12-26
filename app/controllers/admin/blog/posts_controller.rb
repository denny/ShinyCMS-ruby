# Admin controller for blog posts
class Admin::Blog::PostsController < AdminController
  before_action :set_blog
  before_action :set_post_for_create, only: %i[ create ]
  before_action :set_post, only: %i[ edit update delete ]
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
    if @post.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @post.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  rescue ActiveRecord::NotNullViolation
    redirect_with_alert new_admin_blog_post_path, t( '.failure' )
  end

  def edit; end

  def update
    if @post.update( post_params )
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @post.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def delete
    flash[ :notice ] = t( '.success' ) if @post.destroy
  rescue ActiveRecord::RecordNotFound, ActiveRecord::NotNullViolation
    redirect_with_alert admin_blog_posts_path, t( '.failure' )
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

  def set_post
    @post = @blog.posts.find( params[:id] )
    authorise @post
  end

  def set_post_for_create
    @post = @blog.posts.new( new_post_params )
    authorise @post
  end

  def new_post_params
    unless current_user.can? :change_author, :blog_posts
      params[ :blog_post ][ :user_id ] = current_user.id
    end

    params.require( :blog_post ).permit(
      :blog_id, :user_id, :title, :slug, :posted_at, :body, :hidden
    )
  end

  def post_params
    unless current_user.can? :change_author, :blog_posts
      params[ :blog_post ][ :user_id ].delete
    end

    params.require( :blog_post ).permit(
      :blog_id, :user_id, :title, :slug, :posted_at, :body, :hidden
    )
  end
end
