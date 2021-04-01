# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# rubocop:disable Style/StaticClass
module ShinyCMS
  # Make these two ActiveRecord methods available to other plugins
  # TODO: FIXME: this feels like Very Bad Design. Find a better way?
  class HasConsentVersion
    # Used in ShinyLists::Subscription
    def self.consent_version_has_many( things, **args )
      ConsentVersion.has_many( things, **args )
    end

    # Used in ShinyLists/db/seeds.rb
    def self.find_or_create_consent_version( **args )
      ConsentVersion.find_or_create_by!( **args )
    end
  end
end
# rubocop:enable Style/StaticClass
