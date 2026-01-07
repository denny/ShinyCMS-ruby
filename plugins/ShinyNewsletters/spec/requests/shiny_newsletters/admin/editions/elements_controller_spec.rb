# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for admin operations on edition elements
RSpec.describe ShinyNewsletters::Admin::Editions::ElementsController, type: :request do
  before do
    admin = create :newsletter_admin
    sign_in admin
  end

  let( :edition ) { create :newsletter_edition }

  describe 'POST /admin/newsletters/editions/1/elements' do
    it 'adds a new element to the edition' do
      new_name = Faker::Books::CultureSeries.unique.civ

      post shiny_newsletters.edition_elements_path( edition ), params: {
        new_element: {
          name: new_name
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.edit_edition_path( edition )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.editions.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.editions.elements.create.success' )
      # expect( response.body ).to have_field with: new_name

      new_element = edition.elements.last
      expect( new_element.name ).to eq new_name.parameterize.underscore
    end
  end

  describe 'DELETE /admin/newsletters/editions/1/elements/2' do
    it 'deletes an element from the edition' do
      element = edition.elements.last
      before = edition.elements.count

      delete shiny_newsletters.edition_element_path( edition, element )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.edit_edition_path( edition )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.editions.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.editions.elements.destroy.success' )

      after = edition.elements.count
      expect( after ).to eq before - 1
    end
  end
end
