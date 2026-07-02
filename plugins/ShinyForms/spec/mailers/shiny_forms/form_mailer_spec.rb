# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the generic form mailer
RSpec.describe ShinyForms::FormMailer, type: :mailer do
  before do
    ShinyCMS::FeatureFlag.enable :send_emails
    ShinyCMS::FeatureFlag.enable :shiny_forms_emails
  end

  after do
    ShinyCMS::FeatureFlag.disable :send_emails
  end

  let( :site_name ) { described_class.new.site_name }
  let( :default_subject ) do
    I18n.t( 'shiny_forms.mailers.form_mailer.default_subject', site_name: site_name )
  end

  describe '.plain' do
    it 'generates a plain text email containing the form data' do
      form1 = create :plain_email_form

      email1 = described_class.with(
        to:        form1.email_to,
        form_name: form1.internal_name,
        form_data: { message: 'Plain text email', subject: 'TEST EMAIL' }
      ).plain_email

      expect { email1.deliver_later }.to have_enqueued_job

      expect( email1.subject ).to eq "[#{site_name}] TEST EMAIL"
      expect( email1.body    ).to include 'message: Plain text email'
    end
  end

  describe '.html_email' do
    it 'generates an MJML-templated HTML-format email containing the form data' do
      form1 = create :template_email_form

      email1 = described_class.with(
        to:        form1.email_to,
        form_name: form1.internal_name,
        form_data: { message: 'Templated email' }
      ).html_email( template_file: form1.filename )

      expect { email1.deliver_later }.to have_enqueued_job

      expect( email1.subject ).to eq default_subject
      expect( email1.parts.second.body ).to include 'Templated email'
    end

    it 'generates a non-sending NullMail if the template file is missing' do
      form1 = create :template_email_form

      mailer1 = described_class.with(
        to:        form1.email_to,
        form_name: form1.internal_name,
        form_data: { message: 'b0rked email' }
      )

      allow( ShinyForms::Form ).to receive( :template_file_exists? ).and_return( false )

      email1 = mailer1.html_email( template_file: form1.filename )

      expect( email1.deliver_now ).to be_falsey
    end
  end
end
