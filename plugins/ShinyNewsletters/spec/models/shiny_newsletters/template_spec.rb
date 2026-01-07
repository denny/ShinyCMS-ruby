# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for newsletter template model
RSpec.describe ShinyNewsletters::Template, type: :model do
  describe 'class methods' do
    describe '.template_file_exists?' do
      it 'returns true if the template file exists on the disk' do
        expect( described_class.template_file_exists?( 'an_example' ) ).to be true
      end

      it 'returns false if the template file does not exist' do
        expect( described_class.template_file_exists?( 'NO_SUCH_FILE' ) ).to be false
      end
    end

    describe '.available_templates' do
      it 'returns the names of the template files in newsletters/templates' do
        expect( described_class.available_templates.size  ).to eq 2
        expect( described_class.available_templates.first ).to eq 'an_example'
        expect( described_class.available_templates.last  ).to eq 'bad_mjml'
      end
    end
  end

  describe 'instance methods' do
    describe '.elements' do
      it 'returns the template elements' do
        template = create :newsletter_template

        expect( template.elements.size ).to eq 5
      end
    end
  end

  describe 'validations' do
    describe 'mjml_syntax' do
      it 'fails to create a new Template if the template file is not valid MJML' do
        template = create :newsletter_template

        update_successful = template.update( filename: 'bad_mjml' )

        expect( update_successful ).to be false
        expect( template.errors.size ).to eq 1
        expect( template.errors.key?( :filename ) ).to be true
        expect( template.errors.full_messages_for( :filename ).first ).to eq "Filename #{I18n.t( 'errors.messages.invalid_mjml' )}"
      end
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end
  end
end
