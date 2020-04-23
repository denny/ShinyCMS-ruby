# frozen_string_literal: true

# Utility functions for dealing with Akismet
module AkismetHelper
  def akismet_enabled?
    feature_enabled?( :akismet_on_comments )
  end

  def akismet_api_key_is_set?
    ENV[ 'AKISMET_API_KEY' ].present?
  end

  def keep_blatant_spam?
    setting( :akismet_blatant_spam ).downcase == 'keep'
  end

  def drop_blatant_spam?
    !keep_blatant_spam?
  end

  def akismet_client
    client = Akismet::Client.new( ENV[ 'AKISMET_API_KEY' ], root_url )
    client.open
    client
  end

  # Note: Akismet throws "Akismet::Error: unknown error" for invalid API keys
  def akismet_check( request, comment )
    akismet_client.check(
      request.ip,
      request.user_agent,
      akismet_comment_details( comment, request.referer )
    )
  end

  def akismet_confirm_spam( comment_ids )
    client = akismet_client
    comments = Comment.where( id: comment_ids )
    comments.each do |comment|
      client.spam(
        comment.ip_address,
        nil, # TODO: comment.user_agent,
        akismet_comment_details( comment )
      )
    end
  end

  def akismet_flag_as_ham( comment_ids )
    client = akismet_client
    comments = Comment.where( id: comment_ids )
    comments.each do |comment|
      client.ham(
        comment.ip_address,
        nil, # TODO: comment.user_agent,
        akismet_comment_details( comment )
      )
    end
  end

  def akismet_comment_details( comment, referer = nil )
    details = {
      text: "#{comment.title} #{comment.body}",
      created_at: comment.created_at || Time.zone.now,
      type: 'comment'
    }
    details[ :referer ] = referer if referer.present?
    merge_author_details( comment, details )
  end

  def merge_author_details( comment, details )
    name  = comment_author_name(  comment )
    email = comment_author_email( comment )
    url   = comment_author_url(   comment )
    details[ :author       ] = name
    details[ :author_email ] = email if email
    details[ :author_url   ] = url   if url
    details
  end

  def comment_author_name( comment )
    comment.author_name || comment.author&.username || 'Anonymous'
  end

  def comment_author_email( comment )
    comment.author_email || comment.author&.email
  end

  def comment_author_url( comment )
    comment.author_url   || comment.author&.website
  end
end
