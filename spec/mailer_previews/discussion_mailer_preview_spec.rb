# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DiscussionMailerPreview', type: :request do
  before :each do
    admin = create :email_admin
    sign_in admin

    u = create :user
    n = create :news_post, author: u
    d = create :discussion, resource: n
    c = create :top_level_comment, discussion: d, author: u
    create :top_level_comment, discussion: d
    create :nested_comment, discussion: d, parent: c

    Setting.set( :all_comment_notifications_email, to: 'test@example.com' )
  end

  describe '.overview_notification' do
    it 'shows the overview notification email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'discussion_mailer_preview-overview_notification'
      )

      expect( response.body ).to have_content 'commented on your site'
    end
  end

  describe '.discussion_notification' do
    it 'shows the discussion notification email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'discussion_mailer_preview-discussion_notification'
      )

      expect( response.body ).to have_content 'commented on your news post'
    end
  end

  describe '.parent_comment_notification' do
    it 'shows the overview notification email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'discussion_mailer_preview-parent_comment_notification'
      )

      expect( response.body ).to have_content 'replied to your comment'
    end
  end
end
