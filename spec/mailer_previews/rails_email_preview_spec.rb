# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RailsEmailPreview', type: :request do
  before :each do
    admin = create :email_admin
    sign_in admin
  end

  describe 'when I load the index page' do
    it 'it shows the list of emails' do
      get rails_email_preview.rep_emails_path

      expect( response.body )
        .to have_content I18n.t( 'rails_email_preview.emails.index.list_title' )
    end
  end
end
