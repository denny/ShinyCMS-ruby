# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for admin operations on template elements
RSpec.describe ShinyNewsletters::Admin::Templates::ElementsController, type: :request do
  before do
    admin = create :newsletter_template_admin
    sign_in admin
  end

  let( :template ) { create :newsletter_template }

  describe 'POST /admin/newsletters/templates/1/elements' do
    it 'adds a new element to the template' do
      new_name = Faker::Books::CultureSeries.unique.civ

      post shiny_newsletters.template_elements_path( template ), params: {
        new_element: {
          name: new_name
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.edit_template_path( template )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.templates.elements.create.success' )
      # expect( response.body ).to have_field with: new_name

      new_element = template.elements.last
      expect( new_element.name ).to eq new_name.parameterize.underscore
    end
  end

  describe 'DELETE /admin/newsletters/templates/1/elements/2' do
    it 'deletes an element from the template' do
      element = template.elements.last
      before = template.elements.count

      delete shiny_newsletters.template_element_path( template, element )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.edit_template_path( template )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.templates.elements.destroy.success' )

      after = template.elements.count
      expect( after ).to eq before - 1
    end
  end
end
