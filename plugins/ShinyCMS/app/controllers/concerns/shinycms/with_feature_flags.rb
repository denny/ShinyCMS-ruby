# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for turning CMS features on/off selectively
  module WithFeatureFlags
    extend ActiveSupport::Concern

    included do
      def enforce_feature_flags( feature_flag_name )
        return if defined?( current_user ) && FeatureFlag.enabled?( feature_flag_name, current_user )
        return if FeatureFlag.enabled? feature_flag_name

        flash[ :alert ] = I18n.t(
          'shinycms.feature_flags.off_alert',
          feature_name: I18n.t( "shinycms.feature_flags.#{feature_flag_name}" )
        )

        # redirect_back_or_to main_app.root_path
        redirect_to main_app.root_path
      end
    end
  end
end
