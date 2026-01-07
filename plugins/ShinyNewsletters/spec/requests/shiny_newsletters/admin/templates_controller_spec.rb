# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for newsletter template admin features

RSpec.describe ShinyNewsletters::Admin::TemplatesController, type: :request do
  before do
    admin = create :newsletter_template_admin
    sign_in admin
  end

  describe 'GET /admin/newsletters/templates' do
    context 'when there are no templates' do
      it "displays the 'no templates found' message" do
        get shiny_newsletters.templates_path

        pager_info = 'No templates found'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end

    context 'when there are templates' do
      it 'displays the list of templates' do
        create_list :newsletter_template, 3

        get shiny_newsletters.templates_path

        pager_info = 'Displaying 3 templates'

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end
    end
  end

  describe 'GET /admin/newsletters/templates/search?q=zing' do
    it 'fetches the list of matching templates' do
      template1 = create :newsletter_template, description: 'zingy-zebra'
      template2 = create :newsletter_template, description: 'awesome-aardvark'

      get shiny_newsletters.search_templates_path, params: { q: 'zing' }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.index.title' ).titlecase

      expect( response.body ).to     have_css 'td', text: template1.name
      expect( response.body ).not_to have_css 'td', text: template2.name
    end
  end

  describe 'GET /admin/newsletters/template/new' do
    it 'loads the form to add a new template' do
      get shiny_newsletters.new_template_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.new.title' ).titlecase
    end
  end

  describe 'POST /admin/newsletters/template/new' do
    it 'fails when the form is submitted without all the details' do
      post shiny_newsletters.templates_path, params: {
        template: {
          filename: 'an_example'
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_newsletters.admin.templates.create.failure' )
    end

    it 'adds a new template when the form is submitted' do
      post shiny_newsletters.templates_path, params: {
        template: {
          name:     'Test',
          filename: 'an_example'
        }
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.templates.create.success' )
    end

    it 'adds the right number of elements to the new template' do
      post shiny_newsletters.templates_path, params: {
        template: {
          name:     'Another test',
          filename: 'an_example'
        }
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.templates.create.success' )
      expect( ShinyNewsletters::TemplateElement.count ).to eq 5
    end
  end

  describe 'GET /admin/newsletters/template/:id' do
    it 'loads the form to edit an existing template' do
      template = create :newsletter_template

      get shiny_newsletters.edit_template_path( template )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.edit.title' ).titlecase
    end
  end

  describe 'POST /admin/newsletters/template/:id' do
    it 'fails to update the template when submitted without all the details' do
      template = create :newsletter_template

      put shiny_newsletters.template_path( template ), params: {
        template: {
          name: nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_newsletters.admin.templates.update.failure' )
    end

    it 'updates the template when the form is submitted' do
      template = create :newsletter_template
      e_id = ShinyNewsletters::TemplateElement.last.id

      put shiny_newsletters.template_path( template ), params: {
        'template[name]':                    'Updated by test',
        "elements[element_#{e_id}_name]":    'updated_element_name',
        "elements[element_#{e_id}_content]": 'Default content',
        "elements[element_#{e_id}_type]":    'html'
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.templates.update.success' )
      expect( response.body ).to have_field 'template[name]', with: 'Updated by test'
    end

    it 'updates the element order' do
      template = create :newsletter_template
      last_element = template.elements.last

      # Put the last element first
      ids = template.elements.ids
      last_id = ids.pop
      ids.unshift last_id

      query_string = ''
      ids.each do |id|
        query_string += "sorted[]=#{id}&"
      end

      expect( last_element.position ).to eq ids.size

      put shiny_newsletters.template_path( template ), params: {
        template:   {
          name: template.name
        },
        sort_order: query_string
      }

      expect( response      ).to have_http_status :found
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.templates.update.success' )

      expect( last_element.reload.position ).to eq 1
    end
  end

  describe 'DELETE /admin/newsletters/template/delete/:id' do
    it 'deletes the specified templates' do
      t1 = create :newsletter_template
      t2 = create :newsletter_template
      create :newsletter_template

      delete shiny_newsletters.template_path( t2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_newsletters.templates_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_newsletters.admin.templates.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success',
                                              text: I18n.t( 'shiny_newsletters.admin.templates.destroy.success' )
      expect( response.body ).to     have_css 'td', text: t1.name
      expect( response.body ).not_to have_css 'td', text: t2.name
    end

    it 'fails gracefully when attempting to delete a template which is in use' do
      t1 = create :newsletter_template
      create :newsletter_edition, template: t1

      delete shiny_newsletters.template_path( t1 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.templates_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.templates.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_newsletters.admin.templates.destroy.failure' )
      expect( response.body ).to have_css 'td', text: t1.name
    end
  end
end
