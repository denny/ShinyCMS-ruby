require 'rails_helper'

RSpec.describe 'Discussion mailer', type: :mailer do
  before :each do
    create :feature_flag, name: 'comment_notifications', enabled: true

    blog_post   = create :blog_post
    @discussion = create :discussion, resource: blog_post
  end

  describe '.notify_parent_comment_author' do
    it 'generates an email to an authenticated parent comment author' do
      user  = create :user
      top   = create :top_level_comment, discussion: @discussion, author: user
      reply = create :nested_comment, parent: top, discussion: @discussion

      email = DiscussionMailer.parent_comment_notification( reply )

      site_name = I18n.t( 'discussion_mailer.site_name' )
      subject = I18n.t(
        'discussion_mailer.parent_comment_notification.subject',
        reply_author_name: reply.author_name_any,
        site_name: site_name
      )

      expect( email.subject ).to eq subject
    end

    it 'generates an email to a pseudonymous parent comment author' do
      top   = create :top_level_comment, discussion: @discussion,
                                         author_type: 'Pseudonymous',
                                         author_name: 'Test Suite',
                                         author_email: 'test@example.com'
      reply = create :nested_comment, parent: top, discussion: @discussion

      email = DiscussionMailer.parent_comment_notification( reply )

      site_name = I18n.t( 'discussion_mailer.site_name' )
      subject = I18n.t(
        'discussion_mailer.parent_comment_notification.subject',
        reply_author_name: reply.author_name_any,
        site_name: site_name
      )

      expect( email.subject ).to eq subject
    end
  end
end
