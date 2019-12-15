require 'rails_helper'

RSpec.describe 'Admin: Shared Content', type: :request do
  before :each do
    admin = create :shared_content_admin
    sign_in admin
  end

  describe 'GET /admin/shared-content' do
    it 'fetches the shared content page in the admin area' do
      get admin_shared_content_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.shared_content.shared_content' ).titlecase
    end
  end

  describe 'POST /admin/shared-content/create' do
    it 'adds a new Short Text element' do
      post admin_shared_content_create_path, params: {
        'shared_content_element[name]': 'new_shared_content',
        'shared_content_element[content]': 'NEW AND IMPROVED!',
        'shared_content_element[content_type]': I18n.t( 'admin.elements.short_text' )
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_shared_content_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.shared_content.shared_content' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.shared_content.shared_content_created' )
      expect( response.body ).to include 'new_shared_content'
    end

    it 'adds a new element, with an empty content string' do
      post admin_shared_content_create_path, params: {
        'shared_content_element[name]': 'shared_content_is_empty',
        'shared_content_element[content]': '',
        'shared_content_element[content_type]': I18n.t( 'admin.elements.short_text' )
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_shared_content_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.shared_content.shared_content' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.shared_content.shared_content_created' )
      expect( response.body ).to include 'shared_content_is_empty'
    end

    it 'adds a new element, with a NULL content string' do
      post admin_shared_content_create_path, params: {
        'shared_content_element[name]': 'shared_content_is_null',
        'shared_content_element[content]': nil,
        'shared_content_element[content_type]': I18n.t( 'admin.elements.short_text' )
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_shared_content_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.shared_content.shared_content' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.shared_content.shared_content_created' )
      expect( response.body ).to include 'shared_content_is_null'
    end

    it 'attempting to add a new shared_content element with no name fails gracefully' do
      post admin_shared_content_create_path, params: {
        'shared_content_element[content]': 'MADE OF FAIL!'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_shared_content_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.shared_content.shared_content' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.shared_content.shared_content_create_failed' )
    end
  end

  describe 'DELETE /admin/shared-content/delete/:id' do
    it 'deletes the specified piece of shared content' do
      s1 = create :shared_content_element
      s2 = create :shared_content_element, name: 'do_not_want'
      s3 = create :shared_content_element

      delete admin_shared_content_delete_path( s2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to admin_shared_content_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.shared_content.shared_content' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.shared_content.shared_content_deleted' )
      expect( response.body ).to     include s1.name
      expect( response.body ).to     include s3.name
      expect( response.body ).not_to include 'do_not_want'
    end

    it 'fails gracefully when attempting to delete non-existent shared content' do
      delete admin_shared_content_delete_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to admin_shared_content_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.shared_content.shared_content' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.shared_content.shared_content_delete_failed' )
    end
  end

  describe 'POST /admin/shared-content' do
    it 'updates any shared content that was changed' do
      create :shared_content_element
      s2 = create :shared_content_element, content: 'Original content'
      create :shared_content_element

      post admin_shared_content_path, params: {
        "shared_content[elements_attributes][1][id]": s2.id,
        "shared_content[elements_attributes][1][content]": 'Updated content',
        "shared_content[elements_attributes][1][content_type]": 'Short Text'
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to admin_shared_content_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.shared_content.shared_content' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.shared_content.shared_content_updated' )
      expect( response.body ).not_to include 'Original content'
      expect( response.body ).to     include 'Updated content'
    end
  end
end
