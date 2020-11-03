# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the generic form mailer
module ShinyForms
  RSpec.describe FormMailer, type: :mailer do
    before :each do
      FeatureFlag.enable :shiny_forms_emails

      @default_subject = I18n.t( 'shiny_forms.mailers.form_mailer.default_subject', site_name: Setting.get( :site_name ) )
    end

    describe '.plain' do
      it 'generates a plain text email containing the form data' do
        form1 = create :plain_email_form

        email1 = FormMailer.plain( form1, form1.internal_name, { message: 'Plain text email' } )

        expect { email1.deliver_later }.to have_enqueued_job

        expect( email1.subject ).to eq @default_subject
        expect( email1.body    ).to include 'message: Plain text email'
      end
    end

    describe '.with_template' do
      it 'generates an MJML-templated email containing the form data' do
        form1 = create :template_email_form

        email1 = FormMailer.with_template( form1, form1.internal_name, { message: 'Templated email' }, form1.filename )

        expect { email1.deliver_later }.to have_enqueued_job

        expect( email1.subject ).to eq @default_subject
        expect( email1.parts.second.body ).to include 'Templated email'
      end
    end
  end
end
