# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for admin operations on page template elements
RSpec.describe ShinyPages::Admin::Templates::ElementsController, type: :request do
  before do
    admin = create :page_template_admin
    sign_in admin
  end

  let( :template ) { create :page_template }

  describe 'POST /admin/pages/templates/1/elements' do
    it 'adds a new element to the template' do
      new_name = Faker::Books::CultureSeries.unique.civ

      post shiny_pages.template_elements_path( template ), params: {
        new_element: {
          name: new_name
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_template_path( template )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.templates.elements.create.success' )
      # expect( response.body ).to have_field with: new_name

      new_element = template.elements.last
      expect( new_element.name ).to eq new_name.parameterize.underscore
    end
  end

  describe 'DELETE /admin/pages/templates/1/elements/2' do
    it 'deletes an element from the template' do
      element = template.elements.last
      before = template.elements.count

      delete shiny_pages.template_element_path( template, element )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_pages.edit_template_path( template )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_pages.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_pages.admin.templates.elements.destroy.success' )

      after = template.elements.count
      expect( after ).to eq before - 1
    end
  end
end
