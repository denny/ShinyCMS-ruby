# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Reusable spec to check that each admin type gets redirected correctly on login
RSpec.shared_examples '/admin redirect' do |type, path, section, plugin|
  it "redirects a #{type.titlecase} correctly" do
    # rubocop:disable Rails/SaveBang
    admin = create type.to_sym
    sign_in admin
    # rubocop:enable Rails/SaveBang

    title_string = "admin.#{section}.index.title"
    title_string = "#{plugin}.#{title_string}" if plugin.present?

    get admin_path

    expect( response      ).to have_http_status :found
    expect( response      ).to redirect_to url_for( path )
    follow_redirect!
    expect( response      ).to have_http_status :ok
    expect( response.body ).to have_title I18n.t( title_string ).titlecase
  end
end
