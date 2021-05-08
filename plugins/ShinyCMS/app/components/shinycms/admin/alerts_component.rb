# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Component to render the alerts in the admin area
    class AlertsComponent < ApplicationComponent
      # This is all of CoreUI's built-in alert styles (in case anyone wants them in future),
      # plus the Rails default flash keys (alert & notice) mapped to suitable CoreUI styles.
      ALERT_TYPES = {
        # flash_key:     'css-class'
        alert_danger:    'alert-danger',  # red
        alert:           'alert-danger',
        alert_warning:   'alert-warning', # orange
        alert_success:   'alert-success', # green
        notice:          'alert-success',
        alert_info:      'alert-info',    # blue
        alert_primary:   'alert-primary',
        alert_secondary: 'alert-secondary',
        alert_light:     'alert-light',
        alert_dark:      'alert-dark'
      }.freeze
      private_constant :ALERT_TYPES

      def initialize( flash: )
        @alert_types = ALERT_TYPES
        @flash = flash
      end
    end
  end
end
