# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper method for checking feature flag status in views
  module FeatureFlagsHelper
    def feature_enabled?( feature_name )
      return FeatureFlag.enabled? feature_name unless current_user

      FeatureFlag.enabled? feature_name, current_user
    end
  end
end
