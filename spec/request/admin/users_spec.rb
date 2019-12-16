require 'rails_helper'

RSpec.describe 'Admin: Users', type: :request do
  context 'With a normal user admin' do
    before :each do
      admin = create :user_admin
      sign_in admin
    end

    describe 'GET /admin/users' do
      it 'fetches the list of users in the admin area' do
        user = create :user

        get admin_users_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.list_users' ).titlecase
        expect( response.body ).to include user.username
      end
    end

    describe 'GET /admin/user/new' do
      it 'loads the form to add a new user' do
        get admin_user_new_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.new_user' ).titlecase
      end
    end

    describe 'POST /admin/user/new' do
      it 'fails when the form is submitted without all the details' do
        post admin_user_new_path, params: {
          'user[username]': Faker::Internet.unique.username
        }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.new_user' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.users.user_create_failed' )
      end

      it 'fails when the username collides with an existing username' do
        create :user, username: 'test'

        post admin_user_new_path, params: {
          'user[username]': 'test',
          'user[password]': Faker::Internet.unique.password,
          'user[email]': Faker::Internet.unique.email
        }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.new_user' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.users.user_create_failed' )
      end

      it 'adds a new user when the form is submitted' do
        post admin_user_new_path, params: {
          'user[username]': Faker::Internet.unique.username,
          'user[password]': Faker::Internet.unique.password,
          'user[email]': Faker::Internet.unique.email
        }

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to admin_user_path( User.last )
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.edit_user' ).titlecase
        expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.users.user_created' )
      end
    end

    describe 'GET /admin/user/:id' do
      it 'loads the form to edit an existing user, without the section for editing abilities' do
        user = create :user

        get admin_user_path( user )

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'admin.users.edit_user' ).titlecase
        expect( response.body ).not_to have_css 'th', text: I18n.t( 'capability.capabilities' )
      end
    end

    describe 'POST /admin/user/:id' do
      it 'fails to update the user when submitted with a blank username' do
        user = create :user

        post admin_user_path( user ), params: {
          'user[username]': ''
        }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.edit_user' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.users.user_update_failed' )
      end

      it 'updates the user when the form is submitted' do
        user = create :user

        post admin_user_path( user ), params: {
          'user[username]': 'new_username'
        }

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to admin_user_path( user )
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.edit_user' ).titlecase
        expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.users.user_updated' )
        expect( response.body ).to include 'new_username'
      end
    end

    describe 'DELETE /admin/user/delete/:id' do
      it 'deletes the specified user' do
        u1 = create :user
        u2 = create :user
        u3 = create :user

        delete admin_user_delete_path( u2 )

        expect( response      ).to     have_http_status :found
        expect( response      ).to     redirect_to admin_users_path
        follow_redirect!
        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'admin.users.list_users' ).titlecase
        expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.users.user_deleted' )
        expect( response.body ).to     include u1.username
        expect( response.body ).not_to include u2.username
        expect( response.body ).to     include u3.username
      end

      it 'fails gracefully when attempting to delete a non-existent user' do
        delete admin_user_delete_path( 999 )

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to admin_users_path
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.list_users' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.users.user_delete_failed' )
      end
    end
  end

  context 'with a super admin' do
    before :each do
      admin = create :super_admin
      sign_in admin
    end

    describe 'GET /admin/user/:id' do
      it "includes section for editing user's admin capabilities" do
        user = create :user

        get admin_user_path( user )

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.edit_user' ).titlecase
        expect( response.body ).to have_css 'th', text: I18n.t( 'capability.capabilities' )
      end
    end
  end
end
