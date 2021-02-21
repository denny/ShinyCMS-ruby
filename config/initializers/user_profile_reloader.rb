# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Make sure Profile and User stay connected after reloads

Rails.application.reloader.to_prepare do
  ShinyCMS::User.has_one :profile, inverse_of: :user, class_name: 'ShinyProfiles::Profile', dependent: :destroy
  ShinyCMS::User.after_create :create_profile
end
