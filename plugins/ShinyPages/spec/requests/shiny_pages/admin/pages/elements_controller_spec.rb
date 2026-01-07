# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for admin operations on page elements
RSpec.describe ShinyPages::Admin::Pages::ElementsController, type: :request do
  before do
    admin = create :page_admin
    sign_in admin
  end

  let( :page ) { create :top_level_page }

  describe 'POST /admin/pages/1/elements' do
    it 'adds a new element to the page' do
      new_name = Faker::Books::CultureSeries.unique.civ

      post shiny_pages.page_elements_path( page ), params: {
        new_element: {
          name: new_name
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_page_path( page )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.pages.elements.create.success' )
      # expect( response.body ).to have_field with: new_name

      new_element = page.elements.last
      expect( new_element.name ).to eq new_name.parameterize.underscore
    end
  end

  describe 'DELETE /admin/pages/1/elements/2' do
    it 'deletes an element from the page' do
      element = page.elements.last
      before = page.elements.count

      delete shiny_pages.page_element_path( page, element )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_page_path( page )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.pages.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.pages.elements.destroy.success' )

      after = page.elements.count
      expect( after ).to eq before - 1
    end
  end
end
