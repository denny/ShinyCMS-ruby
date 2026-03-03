# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the ShinyCMS route delegator
RSpec.describe ShinyCMS::RouteDelegator, type: :helper do
  describe 'trying to use a path helper method not defined in the engine' do
    context 'when the path helper method is defined in the main app' do
      it 'finds a path helper method which is not defined in the engine but is defined in the main app' do
        # (Note: for this test, it only matters that the path helper exists, not what the route actually does)
        result = Blazer::BaseController.render( inline: '<%= admin_not_found_path( "real-route" ) %>' )

        expect( result ).to eq '/admin/real-route'
      end
    end

    context 'when the path helper method is not defined in the main app either' do
      it 'fails for a path helper method which is not defined in the main app either' do
        expect { Blazer::BaseController.render( inline: '<%= no_such_route_path %>' ) }
          .to raise_error ActionView::Template::Error
      end
    end
  end
end
