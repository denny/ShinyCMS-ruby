require 'rails_helper'

RSpec.describe 'Admin: Inserts', type: :request do
  before :each do
    admin = create :insert_admin
    sign_in admin

    @set = InsertSet.first
  end

  describe 'GET /admin/inserts' do
    it 'fetches the inserts page in the admin area' do
      get inserts_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.inserts.index.title' ).titlecase
    end
  end

  describe 'POST /admin/inserts/create' do
    it 'adds a new Short Text element' do
      post create_insert_path, params: {
        'insert_element[name]': 'new_insert',
        'insert_element[content]': 'NEW AND IMPROVED!',
        'insert_element[content_type]': I18n.t( 'admin.elements.short_text' )
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to inserts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.inserts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.inserts.create.success' )
      expect( response.body ).to include 'new_insert'
    end

    it 'adds a new element, with an empty content string' do
      post create_insert_path, params: {
        'insert_element[name]': 'insert_is_empty',
        'insert_element[content]': '',
        'insert_element[content_type]': I18n.t( 'admin.elements.short_text' )
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to inserts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.inserts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.inserts.create.success' )
      expect( response.body ).to include 'insert_is_empty'
    end

    it 'adds a new element, with a NULL content string' do
      post create_insert_path, params: {
        'insert_element[name]': 'insert_is_null',
        'insert_element[content]': nil,
        'insert_element[content_type]': I18n.t( 'admin.elements.short_text' )
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to inserts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.inserts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.inserts.create.success' )
      expect( response.body ).to include 'insert_is_null'
    end

    it 'attempting to add a new insert element with no name fails gracefully' do
      post create_insert_path, params: {
        'insert_element[content]': 'MADE OF FAIL!'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to inserts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.inserts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.inserts.create.failure' )
    end
  end

  describe 'DELETE /admin/inserts/delete/:id' do
    it 'deletes the specified insert' do
      s1 = create :insert_element, set: @set
      s2 = create :insert_element, set: @set, name: 'do_not_want'
      s3 = create :insert_element, set: @set

      delete insert_path( s2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to inserts_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.inserts.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.inserts.destroy.success' )
      expect( response.body ).to     include s1.name
      expect( response.body ).to     include s3.name
      expect( response.body ).not_to include 'do_not_want'
    end

    it 'fails gracefully when attempting to delete non-existent insert' do
      delete insert_path( 999 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to inserts_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.inserts.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.inserts.destroy.failure' )
    end
  end

  describe 'POST /admin/inserts' do
    it 'updates any insert that was changed' do
      create :insert_element, set: @set
      s2 = create :insert_element, set: @set, content: 'Original content'
      create :insert_element, set: @set

      # Note: the [1] here means 'the second item on the form'; it's not a db id
      put inserts_path, params: {
        "insert_set[elements_attributes][1][id]": s2.id,
        "insert_set[elements_attributes][1][name]": s2.name,
        "insert_set[elements_attributes][1][content]": 'Updated content',
        "insert_set[elements_attributes][1][content_type]": s2.content_type
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to inserts_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.inserts.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.inserts.update.success' )
      expect( response.body ).not_to include 'Original content'
      expect( response.body ).to     include 'Updated content'
    end

    it 'shows an error message if insert names collide' do
      s1 = create :insert_element, set: @set
      s2 = create :insert_element, set: @set, content: 'Original content'
      create :insert_element, set: @set

      # Note: the [0] here means 'the first item on the form'; it's not a db id
      put inserts_path, params: {
        "insert_set[elements_attributes][1][id]": s2.id,
        "insert_set[elements_attributes][1][name]": s1.name,
        "insert_set[elements_attributes][1][content]": 'Updated content',
        "insert_set[elements_attributes][1][content_type]": s2.content_type
      }

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to inserts_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'admin.inserts.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-danger', text: I18n.t( 'admin.inserts.update.failure' )
      expect( response.body ).to     include 'Original content'
      expect( response.body ).not_to include 'Updated content'
    end
  end
end
