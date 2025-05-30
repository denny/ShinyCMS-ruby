# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    module Menu
      # Component to render Coverband item in admin menu
      class CoverbandComponent < ApplicationComponent
        def initialize( current_user: )
          @current_user = current_user
          @coverband_web_ui_enabled = coverband_web_ui_enabled?
        end

        def coverband_web_ui_enabled?
          !coverband_web_ui_disabled?
        end

        def coverband_web_ui_disabled?
          Rails.env.test? || ENV['DISABLE_COVERBAND_WEB_UI']&.downcase == 'true'
        end
      end
    end
  end
end
