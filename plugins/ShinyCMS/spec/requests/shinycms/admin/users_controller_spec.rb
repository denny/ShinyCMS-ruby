# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for user admin features
RSpec.describe ShinyCMS::Admin::UsersController, type: :request do
  context 'with a normal user admin' do
    before do
      admin = create :user_admin
      sign_in admin
    end

    let( :test_username ) { Faker::Internet.unique.username( specifier:   5 ) }
    let( :test_password ) { Faker::Internet.unique.password( min_length: 10 ) }

    let( :test_email ) { Faker::Internet.unique.email( name: test_username ) }

    describe 'GET /admin/users' do
      it 'displays the list of users' do
        create_list :user, 3

        get shinycms.users_path

        pager_info = 'Displaying 4 users'  # including the admin user

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.index.title' ).titlecase
        expect( response.body ).to have_css '.pager-info', text: pager_info
      end

      it 'handles page number and items-per-page params correctly' do
        user1 = create :user, username: 'aaaaa_again_with_the_apples'
        user2 = create :user, username: 'aaaaa_bendy_bananas'
        user3 = create :user, username: 'aaaaa_cool_cucumbers'

        get shinycms.users_path, params: { page: 2, items: 2 }

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'shinycms.admin.users.index.title' ).titlecase
        expect( response.body ).to     have_css 'td', text: user3.username
        expect( response.body ).not_to have_css 'td', text: user2.username
        expect( response.body ).not_to have_css 'td', text: user1.username
      end
    end

    describe 'GET /admin/users/search?q=bobx' do
      it 'fetches the list of users with matching email addresses' do
        user_a = create :user, email: 'testamy@example.com'
        user_b = create :user, email: 'testbob@example.com'

        get shinycms.search_users_path, params: { q: 'stbob' }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.index.title' ).titlecase

        expect( response.body ).not_to have_css 'td', text: user_a.username
        expect( response.body ).to     have_css 'td', text: user_b.username
      end
    end

    describe 'GET /admin/users/usernames?term=art' do
      it 'returns the list of matching usernames' do
        user_x = create :user, username: 'PartlyHere'
        user_y = create :user, username: 'FullyThere'

        get shinycms.search_usernames_path, params: { term: 'art' }

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     include user_x.username
        expect( response.body ).not_to include user_y.username
      end
    end

    describe 'GET /admin/user/new' do
      it 'loads the form to add a new user' do
        get shinycms.new_user_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.new.title' ).titlecase
        expect( response.body ).to have_field 'user[username]'
      end
    end

    describe 'POST /admin/user/new' do
      it 'fails when the form is submitted without all the details' do
        post shinycms.users_path, params: { user: { username: test_username } }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.new.title' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shinycms.admin.users.create.failure' )
      end

      it 'fails when the username collides with an existing username' do
        create :user, username: 'existing_user'

        post shinycms.users_path, params: {
          user: {
            username: 'existing_user',
            password: test_password,
            email:    test_email
          }
        }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.new.title' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shinycms.admin.users.create.failure' )
      end

      it 'adds a new user when the form is submitted' do
        post shinycms.users_path, params: {
          user: {
            username: test_username,
            password: test_password,
            email:    test_email
          }
        }

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to shinycms.edit_user_path( ShinyCMS::User.last )
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.edit.title' ).titlecase
        expect( response.body ).to have_field 'user[username]', with: test_username
        expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shinycms.admin.users.create.success' )
      end
    end

    describe 'GET /admin/user/:id' do
      it 'loads the form to edit an existing user, without the section for editing abilities' do
        user = create :user

        get shinycms.edit_user_path( user )

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'shinycms.admin.users.edit.title' ).titlecase
        expect( response.body ).to     have_field 'user[username]', with: user.username
        expect( response.body ).not_to have_css 'th', text: I18n.t( 'shinycms.capability.capabilities' )
      end
    end

    describe 'POST /admin/user/:id' do
      it 'fails to update the user when submitted with a blank username' do
        user = create :user

        put shinycms.user_path( user ), params: { user: { username: '' } }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.edit.title' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shinycms.admin.users.update.failure' )
      end

      it 'updates the user when the form is submitted' do
        user = create :user

        put shinycms.user_path( user ), params: { user: { username: 'new_username' } }

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to shinycms.edit_user_path( user )
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.edit.title' ).titlecase
        expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shinycms.admin.users.update.success' )
        expect( response.body ).to have_field 'user[username]', with: 'new_username'
      end
    end

    describe 'DELETE /admin/user/delete/:id' do
      it 'deletes the specified user' do
        u1 = create :user
        u2 = create :user
        u3 = create :user

        delete shinycms.user_path( u2 )

        expect( response      ).to     have_http_status :found
        expect( response      ).to     redirect_to shinycms.users_path
        follow_redirect!
        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'shinycms.admin.users.index.title' ).titlecase
        expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shinycms.admin.users.destroy.success' )
        expect( response.body ).to     have_css 'td', text: u1.username
        expect( response.body ).not_to have_css 'td', text: u2.username
        expect( response.body ).to     have_css 'td', text: u3.username
      end

      it 'fails gracefully when attempting to delete a user with non-deletable content' do
        u1 = create :user
        create :blog_post, user: u1

        delete shinycms.user_path( u1 )

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to shinycms.users_path
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.index.title' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shinycms.admin.users.destroy.failure' )
      end
    end
  end

  context 'with a super admin' do
    before do
      admin = create :super_admin
      sign_in admin
    end

    describe 'GET /admin/user/:id' do
      it "includes section for editing user's admin capabilities" do
        user = create :user

        get shinycms.edit_user_path( user )

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.edit.title' ).titlecase
        expect( response.body ).to have_css 'th', text: I18n.t( 'shinycms.capability.capabilities' )
        expect( response.body ).to have_css 'td', text: I18n.t( 'list'    )
        expect( response.body ).to have_css 'td', text: I18n.t( 'destroy' )
      end
    end

    it 'updates the admin capabilities when the form is submitted' do
      user = create :user

      capability_id = ShinyCMS::Capability.where( name: 'view_admin_area' ).pick( :id )
      field_name = "user[capabilities][#{capability_id}]"

      expect( user.capabilities.length ).to eq 0

      put shinycms.user_path( user ), params: { "#{field_name}": 'on' }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.edit_user_path( user )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.admin.users.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shinycms.admin.users.update.success' )
      expect( response.body ).to have_field field_name, with: 'on'
      user.reload
      expect( user.capabilities.length ).to eq 1
      expect( user.capabilities.first.name ).to eq 'view_admin_area'
    end
  end
end
