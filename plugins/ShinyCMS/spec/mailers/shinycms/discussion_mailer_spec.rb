# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the discussion mailer (reply notifications)
RSpec.describe ShinyCMS::DiscussionMailer, type: :mailer do
  before do
    ShinyCMS::FeatureFlag.enable :comment_notifications

    blog_post   = create :blog_post
    @discussion = create :discussion, resource: blog_post
  end

  let( :site_name ) { ShinyCMS::Setting.get( :site_name ) || I18n.t( 'site_name' ) }

  describe '.parent_comment_notification' do
    it 'generates an email to an authenticated parent comment author' do
      user  = create :user
      top   = create :top_level_comment, discussion: @discussion, author: user
      reply = create :nested_comment, parent: top, discussion: @discussion

      email = described_class.parent_comment_notification( reply )

      subject = I18n.t(
        'shinycms.discussion_mailer.parent_comment_notification.subject',
        reply_author_name: reply.author_name_or_anon,
        site_name:         site_name
      )

      expect( email.subject ).to eq subject
    end

    it 'generates an email to a pseudonymous parent comment author' do
      recipient = create :email_recipient, :confirmed
      author = create :comment_author, name: recipient.name, email_recipient: recipient
      top = create :top_level_comment, discussion: @discussion, author: author

      reply = create :nested_comment, parent: top, discussion: @discussion

      email = described_class.parent_comment_notification( reply )

      subject = I18n.t(
        'shinycms.discussion_mailer.parent_comment_notification.subject',
        reply_author_name: reply.author_name_or_anon,
        site_name:         site_name
      )

      expect( email.subject ).to eq subject
    end
  end

  describe '.discussion_notification' do
    it 'generates email to author/owner of resource that discussion is attached to' do
      comment = create :top_level_comment, discussion: @discussion

      email = described_class.discussion_notification( comment )

      subject = I18n.t(
        'shinycms.discussion_mailer.discussion_notification.subject',
        comment_author_name: comment.author_name_or_anon,
        content_type:        I18n.t( 'shinycms.models.names.shiny_blog_post' ),
        site_name:           site_name
      )

      expect( email.subject ).to eq subject
    end
  end

  describe '.overview_notification' do
    it 'generates notification email to comment overview address' do
      ShinyCMS::Setting.set( :all_comment_notifications_email, to: 'test@example.com' )

      comment = create :top_level_comment, discussion: @discussion

      email = described_class.overview_notification( comment )

      subject = I18n.t(
        'shinycms.discussion_mailer.overview_notification.subject',
        comment_author_name: comment.author_name_or_anon,
        site_name:           site_name
      )

      expect( email.subject ).to eq subject
    end
  end
end
