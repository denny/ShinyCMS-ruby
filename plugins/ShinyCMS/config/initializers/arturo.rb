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
    user_signed_in? && current_user.can?( :edit, :feature_flags )
  end
end

# :nocov:

return if Rails.env.test? || Rails.env.development?

# Caching for Feature lookups - https://github.com/zendesk/arturo#caching
Arturo::Feature.extend( Arturo::FeatureCaching )
Arturo::Feature.cache_ttl = 1.minute
