# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the discussion mailer (reply notifications)
RSpec.describe DiscussionMailer, type: :mailer do
  before :each do
    FeatureFlag.enable :comment_notifications

    @site_name = ::Setting.get( :site_name ) || I18n.t( 'site_name' )

    blogger     = create :blog_admin
    blog_post   = create :blog_post, author: blogger
    @discussion = create :discussion, resource: blog_post
  end

  describe '.parent_comment_notification' do
    it 'generates an email to an authenticated parent comment author' do
      user  = create :user
      top   = create :top_level_comment, discussion: @discussion, author: user
      reply = create :nested_comment, parent: top, discussion: @discussion

      email = DiscussionMailer.parent_comment_notification( reply )

      subject = I18n.t(
        'discussion_mailer.parent_comment_notification.subject',
        reply_author_name: reply.author_name_any,
        site_name: @site_name
      )

      expect( email.subject ).to eq subject
    end

    it 'generates an email to a pseudonymous parent comment author' do
      recipient = create :confirmed_email_recipient
      top = create :top_level_comment,  discussion: @discussion,
                                        author_type: 'Pseudonymous',
                                        author_name: 'Test Suite',
                                        author_email: recipient.email
      reply = create :nested_comment, parent: top, discussion: @discussion

      email = DiscussionMailer.parent_comment_notification( reply )

      subject = I18n.t(
        'discussion_mailer.parent_comment_notification.subject',
        reply_author_name: reply.author_name_any,
        site_name: @site_name
      )

      expect( email.subject ).to eq subject
    end
  end

  describe '.discussion_notification' do
    it 'generates email to author/owner of resource that discussion is attached to' do
      comment = create :top_level_comment, discussion: @discussion

      email = DiscussionMailer.discussion_notification( comment )

      subject = I18n.t(
        'discussion_mailer.discussion_notification.subject',
        comment_author_name: comment.author_name_any,
        content_type: 'blog post',
        site_name: @site_name
      )

      expect( email.subject ).to eq subject
    end
  end

  describe '.overview_notification' do
    it 'generates notification email to comment overview address' do
      Setting.set( :all_comment_notifications_email, to: 'test@example.com' )

      comment = create :top_level_comment, discussion: @discussion

      email = DiscussionMailer.overview_notification( comment )

      subject = I18n.t(
        'discussion_mailer.overview_notification.subject',
        comment_author_name: comment.author_name_any,
        site_name: @site_name
      )

      expect( email.subject ).to eq subject
    end
  end
end
