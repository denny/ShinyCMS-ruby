# frozen_string_literal: true

# ShinySearch plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinySearch::MainSiteHelper, type: :helper do
  context 'when the ENV var is set to true' do
    describe 'using_paid_algolia_plan?' do
      it 'returns true' do
        allow( ENV ).to receive( :fetch ).with( 'ALGOLIASEARCH_USING_PAID_PLAN', 'false' ).and_return 'true'

        expect( helper.using_paid_algolia_plan? ).to be true
      end
    end

    describe 'using_free_algolia_plan?' do
      it 'returns false' do
        allow( ENV ).to receive( :fetch ).with( 'ALGOLIASEARCH_USING_PAID_PLAN', 'false' ).and_return 'true'

        expect( helper.using_free_algolia_plan? ).to be false
      end
    end
  end

  context 'when the ENV var is set to false' do
    describe 'using_paid_algolia_plan?' do
      it 'returns false' do
        allow( ENV ).to receive( :fetch ).with( 'ALGOLIASEARCH_USING_PAID_PLAN', 'false' ).and_return 'false'

        expect( helper.using_paid_algolia_plan? ).to be false
      end
    end

    describe 'using_free_algolia_plan?' do
      it 'returns true' do
        allow( ENV ).to receive( :fetch ).with( 'ALGOLIASEARCH_USING_PAID_PLAN', 'false' ).and_return 'false'

        expect( helper.using_free_algolia_plan? ).to be true
      end
    end
  end
end
