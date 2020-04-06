require 'rails_helper'

RSpec.describe 'UserMailerPreview', type: :request do
  before :each do
    admin = create :email_admin
    sign_in admin
  end

  describe '.confirmation_instructions' do
    it 'shows the confirmation instructions email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-confirmation_instructions'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.confirmation_instructions.subject' )
    end
  end
end
