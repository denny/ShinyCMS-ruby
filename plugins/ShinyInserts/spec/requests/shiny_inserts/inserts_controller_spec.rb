# frozen_string_literal: true

# ShinyInserts plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe 'ShinyInserts: main site features', type: :request do
  describe 'GET /' do
    it 'fetches the page, including the content of the insert element' do
      page   = create :top_level_page
      insert = create :insert_element,
                      name:    'the_email',
                      content: Faker::Internet.unique.email

      get '/'

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title page.name
      expect( response.body ).to have_css '.small', text: insert.content
    end
  end
end
