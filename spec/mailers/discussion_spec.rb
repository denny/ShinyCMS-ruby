require 'rails_helper'

RSpec.describe 'Discussion mailer', type: :mailer do
  before :each do
    create :feature_flag, name: 'comment_notifications', enabled: true

    blog_post   = create :blog_post
    @discussion = create :discussion, resource: blog_post
    author      = create :user
    @comment    = create :top_level_comment, discussion: @discussion, author: author
  end

  describe 'reply_to_comment' do
    it 'generates an email' do
      reply = create :nested_comment, parent: @comment, discussion: @discussion

      email = DiscussionMailer.reply_to_comment( reply )
      site_name = I18n.t( 'discussion_mailer.reply_to_comment.site_name' )

      subject = I18n.t(
        'discussion_mailer.reply_to_comment.subject',
        reply_author_name: reply.author_name_any,
        site_name: site_name
      )

      expect( email.subject ).to eq subject
    end
  end
end
