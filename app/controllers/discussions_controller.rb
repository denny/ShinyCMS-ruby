# Main site controller for discussions and comments
class DiscussionsController < ApplicationController
  include RecaptchaHelper

  before_action :check_feature_flags
  before_action :stash_discussion, except: :index
  before_action :stash_comment, except: %i[ index show add_comment ]
  before_action :stash_recaptcha_keys, except: %i[ index ]

  def index
    # TODO: list of recently active discussions etc
    redirect_to root_path
  end

  def show; end

  def show_thread
    return if @comment.present?

    @resource_type = 'Comment'
    render 'errors/404', status: :not_found
  end

  def add_comment
    @new_comment = @discussion.comments.new( comment_params )
    save_comment
  end

  def add_reply
    @new_comment = @comment.comments.new( comment_params )
    save_comment
  end

  private

  def save_comment
    if @new_comment.save && recaptcha_pass
      flash[ :notice ] = t( '.success' )
      redirect_back fallback_location: discussion_path( @discussion )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :show
    end
  end

  def stash_discussion
    @discussion = Discussion.find( params[ :id ] )
  rescue ActiveRecord::RecordNotFound
    render 'errors/404', status: :not_found
  end

  def stash_comment
    @comment = @discussion.comments.find_by( number: params[ :number ] ) || nil
  end

  def recaptcha_pass
    return true if @new_comment.user_id.present?

    verify_invisible_recaptcha( 'comment' ) || verify_checkbox_recaptcha
  end

  def comment_params
    p = params.require( :comment ).permit( permitted_param_names )
    p = p.merge( user_id: current_user.id ) if user_signed_in?
    p.merge( discussion_id: @discussion.id )
  end

  def permitted_param_names
    %i[
      title
      body
      author_type
      author_name
      author_email
      author_url
      g-recaptcha-response[comment]
      g-recaptcha-response
    ]
  end

  def stash_recaptcha_keys
    @recaptcha_v3_key = ENV[ 'RECAPTCHA_V3_SITE_KEY' ]
    @recaptcha_v2_key = ENV[ 'RECAPTCHA_V2_SITE_KEY' ]
  end

  def check_feature_flags
    enforce_feature_flags :comments
  end
end
