# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 20092021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Component to render admin sidebar menu
  class Admin::MenuComponent < ApplicationComponent
    def initialize( current_user: )
      @current_user = current_user
      @menu_sections = admin_menu_sections
    end

    def admin_menu_sections
      # TODO: Allow each admin to customise the menu order
      feature_plugin_admin_menu_partials + core_plugin_admin_menu_partials
    end

    # rubocop:disable Layout/MultilineArrayLineBreaks
    def core_plugin_admin_menu_partials
      core_menu_sections = %w[
        email consent_versions other users stats settings
        sidekiq_web coverband
      ]
      core_menu_sections.collect { |name| "admin/menu/#{name}" }
    end
    # rubocop:enable Layout/MultilineArrayLineBreaks

    def feature_plugin_admin_menu_partials
      plugins = ShinyCMS.plugins.with_partial( 'admin/menu/_section.html.erb' )
      return unless plugins

      plugins.collect { |plugin| plugin.partial( 'admin/menu/section' ) }
    end
  end
end
