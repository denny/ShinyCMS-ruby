# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyCMS::ConsentVersion, type: :model do
  describe '#update' do
    it 'raises an error if the consent version has already been agreed to by some people' do
      version1 = create :consent_version
      create :mailing_list_subscription, consent_version: version1

      expect { version1.update( slug: 'new-slug' ) }
        .to raise_error ShinyCMS::ConsentVersion::HasBeenAgreedTo
    end
  end

  describe '#destroy' do
    it 'raises an error if the consent version has already been agreed to by some people' do
      version1 = create :consent_version
      create :mailing_list_subscription, consent_version: version1

      expect { version1.destroy }.to raise_error ShinyCMS::ConsentVersion::HasBeenAgreedTo
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end
  end
end
