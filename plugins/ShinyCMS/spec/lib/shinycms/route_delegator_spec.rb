# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the main_app route delegator (a complex routing bodge sort-of copied from
# RailsEmailPreview (all errors mine!) and used to try to get Blazer to render inside
# my admin layout without wrecking everything - with some but not total success)
RSpec.describe ShinyCMS::RouteDelegator, type: :helper do
  describe 'method_missing' do
    it 'fails correctly for a method which is missing from main app too' do
      expect { ::Ckeditor::PicturesController.new.render( inline: '<%= w0rks? %>' ) }
        .to raise_error ActionView::Template::Error
      end
  end
end
