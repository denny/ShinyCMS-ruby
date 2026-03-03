# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    module Menu
      # Component to render Sidekiq Web item in admin menu
      class SidekiqComponent < ApplicationComponent
        def initialize( current_user: )
          @current_user = current_user
          @sidekiq_web_enabled = sidekiq_web_enabled?
        end

        def sidekiq_web_enabled?
          !sidekiq_web_disabled?
        end

        def sidekiq_web_disabled?
          ENV['DISABLE_SIDEKIQ_WEB']&.downcase == 'true'
        end
      end
    end
  end
end
