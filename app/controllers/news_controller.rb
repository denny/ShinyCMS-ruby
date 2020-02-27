# Main site controller for news section
class NewsController < ApplicationController
  before_action :check_feature_flags

  def index
    page_num = params[:page] || 1
    @posts = NewsPost.recent_posts.page( page_num )
  end

  def month
    @posts = NewsPost.posts_for_month( params[:year], params[:month] )
  end

  def year
    @posts = NewsPost.posts_for_year( params[:year] )
  end

  def show
    @post = NewsPost.find_post( params[:year], params[:month], params[:slug] )
    return if @post.present?

    @resource_type = 'News post'
    render 'errors/404', status: :not_found
  end

  private

  def check_feature_flags
    enforce_feature_flags :news
  end
end
