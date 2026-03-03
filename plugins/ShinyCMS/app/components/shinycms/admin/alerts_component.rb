# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Component to render the alerts in the admin area
    class AlertsComponent < ApplicationComponent
      BOOTSTRAP_ALERT_TYPES = %w[
        alert_danger
        alert_warning
        alert_success
        alert_info
        alert_primary
        alert_secondary
        alert_light
        alert_dark
      ].freeze
      private_constant :BOOTSTRAP_ALERT_TYPES

      RAILS_ALERT_TYPES = %w[ alert notice ].freeze
      private_constant :RAILS_ALERT_TYPES

      ALERT_TYPES = [ RAILS_ALERT_TYPES + BOOTSTRAP_ALERT_TYPES ].flatten.freeze
      private_constant :ALERT_TYPES

      def initialize( flash: )
        @alerts = extract_alerts( flash )
      end

      def extract_alerts( flash_messages )
        flash_messages.to_h.slice( *ALERT_TYPES )
      end
    end
  end
end
