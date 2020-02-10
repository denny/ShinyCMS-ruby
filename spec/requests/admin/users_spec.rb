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

        get users_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.index.title' ).titlecase
        expect( response.body ).to include user.username
      end
    end

    describe 'GET /admin/user/new' do
      it 'loads the form to add a new user' do
        get new_user_path

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.new.title' ).titlecase
      end
    end

    describe 'POST /admin/user/new' do
      it 'fails when the form is submitted without all the details' do
        post create_user_path, params: {
          'user[username]': Faker::Internet.unique.username
        }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.new.title' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.users.create.failure' )
      end

      it 'fails when the username collides with an existing username' do
        create :user, username: 'test'

        post create_user_path, params: {
          'user[username]': 'test',
          'user[password]': Faker::Internet.unique.password,
          'user[email]': Faker::Internet.unique.email
        }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.new.title' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.users.create.failure' )
      end

      it 'adds a new user when the form is submitted' do
        post create_user_path, params: {
          'user[username]': Faker::Internet.unique.username,
          'user[password]': Faker::Internet.unique.password,
          'user[email]': Faker::Internet.unique.email
        }

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to edit_user_path( User.last )
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.edit.title' ).titlecase
        expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.users.create.success' )
      end
    end

    describe 'GET /admin/user/:id' do
      it 'loads the form to edit an existing user, without the section for editing abilities' do
        user = create :user

        get edit_user_path( user )

        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'admin.users.edit.title' ).titlecase
        expect( response.body ).not_to have_css 'th', text: I18n.t( 'capability.capabilities' )
      end
    end

    describe 'POST /admin/user/:id' do
      it 'fails to update the user when submitted with a blank username' do
        user = create :user

        put user_path( user ), params: {
          'user[username]': ''
        }

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.edit.title' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.users.update.failure' )
      end

      it 'updates the user when the form is submitted' do
        user = create :user

        put user_path( user ), params: {
          'user[username]': 'new_username'
        }

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to edit_user_path( user )
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.edit.title' ).titlecase
        expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.users.update.success' )
        expect( response.body ).to include 'new_username'
      end
    end

    describe 'DELETE /admin/user/delete/:id' do
      it 'deletes the specified user' do
        u1 = create :user
        u2 = create :user
        u3 = create :user

        delete user_path( u2 )

        expect( response      ).to     have_http_status :found
        expect( response      ).to     redirect_to users_path
        follow_redirect!
        expect( response      ).to     have_http_status :ok
        expect( response.body ).to     have_title I18n.t( 'admin.users.index.title' ).titlecase
        expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'admin.users.destroy.success' )
        expect( response.body ).to     have_css 'td', text: u1.username
        expect( response.body ).not_to have_css 'td', text: u2.username
        expect( response.body ).to     have_css 'td', text: u3.username
      end

      it 'fails gracefully when attempting to delete a non-existent user' do
        delete user_path( 999 )

        expect( response      ).to have_http_status :found
        expect( response      ).to redirect_to users_path
        follow_redirect!
        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.index.title' ).titlecase
        expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'admin.users.destroy.failure' )
      end
    end
  end

  context 'with a super admin' do
    before :each do
      admin = create :super_admin
      sign_in admin
      create :capability_category, name: 'blog_posts'
      create :capability_category, name: 'feature_flags'
      create :capability_category, name: 'settings'
      create :capability_category, name: 'users'
    end

    describe 'GET /admin/user/:id' do
      it "includes section for editing user's admin capabilities" do
        user = create :user

        get edit_user_path( user )

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_title I18n.t( 'admin.users.edit.title' ).titlecase
        expect( response.body ).to have_css 'th', text: I18n.t( 'capability.capabilities' )
      end
    end

    it 'updates the admin capabilities when the form is submitted' do
      user = create :user

      capability_id = Capability.where( name: 'view_admin_area').pick( :id )
      field_name = "user[capabilities[#{capability_id}]]"

      expect( user.capabilities.length ).to eq 0

      put user_path( user ), params: {
        "#{field_name}": 'on'
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to edit_user_path( user )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'admin.users.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'admin.users.update.success' )
      expect( response.body ).to have_field field_name, with: 'on'
      user.reload
      expect( user.capabilities.length ).to eq 1
      expect( user.capabilities.first.name ).to eq 'view_admin_area'
    end
  end
end
