# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Utility functions for dealing with Akismet
module AkismetHelper
  def akismet_api_key_is_set?
    ENV[ 'AKISMET_API_KEY' ].present?
  end

  def akismet_confirm_spam( comment_ids )
    client = akismet_client
    comments = Comment.where( id: comment_ids )
    comments.each do |comment|
      client.spam(
        comment.ip_address,
        nil, # TODO: comment.user_agent,
        comment_details( comment )
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
        comment_details( comment )
      )
    end
  end

  # Note: Akismet throws "Akismet::Error: unknown error" for invalid API keys
  def akismet_check( request, content )
    akismet_client.check(
      request.ip,
      request.user_agent,
      content_details( content, request.referer )
    )
  end

  private

  def akismet_client
    client = Akismet::Client.new( ENV[ 'AKISMET_API_KEY' ], main_app.root_url )
    client.open
    client
  end

  def content_details( content, referer = nil )
    return comment_details( content, referer ) if content.is_a? Comment

    generic_form_details( content, referer )
  end

  def comment_details( comment, referer = nil )
    details = {
      text: "#{comment.title} #{comment.body}",
      created_at: comment.created_at || Time.zone.now.iso8601,
      type: 'comment'
    }
    details[ :referer ] = referer if referer.present?
    merge_comment_author_details( comment, details )
  end

  def merge_comment_author_details( comment, details )
    email = comment&.author&.email
    url   = comment&.author&.website
    details[ :author       ] = comment.author_name_or_anon
    details[ :author_email ] = email if email
    details[ :author_url   ] = url   if url
    details
  end

  def generic_form_details( form_data, referer = nil )
    details = {
      text: "#{form_data[ :subject ]} #{form_data[ :body ]}",
      created_at: Time.zone.now.iso8601,
      type: 'contact-form'
    }
    details[ :referer ] = referer if referer.present?
    merge_generic_form_author_details( form_data, details )
  end

  def merge_generic_form_author_details( form_data, details )
    name  = form_data[ :author_name  ] || form_data[ :from_name  ] || form_data[ :name  ]
    email = form_data[ :author_email ] || form_data[ :from_email ] || form_data[ :email ]
    details[ :author       ] = name  if name
    details[ :author_email ] = email if email
    details
  end
end
