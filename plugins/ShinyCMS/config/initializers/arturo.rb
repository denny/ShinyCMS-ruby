# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'arturo'
require 'arturo/feature'

Arturo::FeatureManagement.class_eval do
  def may_manage_features?
    current_user&.can? :edit, :feature_flags
  end
end

# Caching for Feature lookups - https://github.com/zendesk/arturo#caching
Arturo::Feature.extend( Arturo::FeatureCaching )
Arturo::Feature.cache_ttl = 1.minute

# Create Arturo grantlists and blocklists from ShinyCMS::FeatureFlags
Rails.application.config.to_prepare do
  ShinyCMS::FeatureFlag.all.each do |flag|
    # binding.pry
    if flag.enabled?
      Arturo::Feature.whitelist( flag.name.to_sym )
    elsif flag.enabled_for_logged_in?
      Arturo::Feature.whitelist( flag.name.to_sym ) { user_signed_in? }
    elsif flag.enabled_for_admins?
      Arturo::Feature.whitelist( flag.name.to_sym, &:admin? )
    else
      Arturo::Feature.blacklist( flag.name.to_sym )
    end
  end
end
