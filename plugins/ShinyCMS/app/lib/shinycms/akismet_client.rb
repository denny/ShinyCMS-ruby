# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for dealing with Akismet
  class AkismetClient
    include ShinyCMS::MainAppRootURL

    attr_reader :client

    def initialize
      @client = ::Akismet::Client.new( ENV[ 'AKISMET_API_KEY' ], main_app_root_url )
      @client.open
    end

    # Fun fact: Akismet::Client throws "Akismet::Error: unknown error" here if API key is invalid
    def check( request, content )
      client.check(
        request.ip,
        request.user_agent,
        content_details( content, request.referer )
      )
    end

    def train_as_spam( comments )
      comments.each do |comment|
        client.spam(
          comment.ip_address,
          nil, # TODO: comment.user_agent,
          comment_details( comment )
        )
      end
    end

    def train_as_ham( comments )
      comments.each do |comment|
        client.ham(
          comment.ip_address,
          nil, # TODO: comment.user_agent,
          comment_details( comment )
        )
      end
    end

    private

    def content_details( content, referer = nil )
      return comment_details( content, referer ) if content.is_a? Comment

      generic_form_details( content, referer )
    end

    def comment_details( comment, referer = nil )
      details = {
        text:       "#{comment.title} #{comment.body}",
        created_at: comment.created_at || Time.zone.now.iso8601,
        type:       'comment'
      }
      details[ :referrer ] = referer if referer.present?
      merge_comment_author_details( comment, details )
    end

    def generic_form_details( form_data, referer = nil )
      details = {
        text:       "#{form_data[ :subject ]} #{form_data[ :body ]}",
        created_at: Time.zone.now.iso8601,
        type:       'contact-form'
      }
      details[ :referrer ] = referer if referer.present?
      merge_generic_form_author_details( form_data, details )
    end

    def merge_comment_author_details( comment, details )
      email = comment.author.email
      url   = comment.author.url
      details[ :author       ] = comment.author.name
      details[ :author_email ] = email if email
      details[ :author_url   ] = url   if url
      details
    end

    def merge_generic_form_author_details( form_data, details )
      name  = form_data[ :author_name  ] || form_data[ :from_name  ] || form_data[ :name  ]
      email = form_data[ :author_email ] || form_data[ :from_email ] || form_data[ :email ]
      details[ :author       ] = name  if name
      details[ :author_email ] = email if email
      details
    end
  end
end
