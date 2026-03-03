# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Tags concern for admin controllers
RSpec.describe ShinyCMS::Admin::WithTags, type: :request do
  before do
    admin = create :blog_admin
    sign_in admin
  end

  describe 'GET /admin/blog/:id/edit' do
    context 'when a visible blog post has tags' do
      it 'they load on its edit page' do
        post = create :blog_post, tag_list: 'test, tag, list'

        expect( post.tag_list.present?        ).to be true
        expect( post.hidden_tag_list.present? ).to be false

        get shiny_blog.edit_blog_post_path( post )

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_field 'post[tag_list]', with: 'test, tag, list'
      end
    end

    context 'when a hidden blog post has tags' do
      it 'they load on its edit page' do
        post = create :blog_post, tag_list: 'test, tag, list'
        post.update!( show_on_site: false )

        expect( post.tag_list.present?        ).to be false
        expect( post.hidden_tag_list.present? ).to be true

        get shiny_blog.edit_blog_post_path( post )

        expect( response      ).to have_http_status :ok
        expect( response.body ).to have_field 'post[tag_list]', with: 'test, tag, list'
      end
    end
  end
end
