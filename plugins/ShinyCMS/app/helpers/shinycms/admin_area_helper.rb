# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for admin area
  module AdminAreaHelper
    def blazer_controller?
      controller.is_a? Blazer::BaseController
    end

    def rep_controller?
      controller.is_a? RailsEmailPreview::ApplicationController
    end

    def shinycms_admin_controller?
      controller.is_a?( ShinyCMS::Admin::BaseController ) &&
        !blazer_controller? && !rep_controller?
    end

    def coverband_web_ui_enabled?
      !coverband_web_ui_disabled?
    end

    def coverband_web_ui_disabled?
      Rails.env.test? || ENV['DISABLE_COVERBAND_WEB_UI']&.downcase == 'true'
    end

    def sidekiq_web_enabled?
      ENV['DISABLE_SIDEKIQ_WEB']&.downcase != 'true'
    end

    def plugin_breadcrumb_link_text_and_path( plugin, controller_name )
      [
        I18n.t( "#{plugin.underscore}.admin.#{controller_name}.breadcrumb" ),
        plugin.engine.routes.url_helpers.public_send( "#{controller_name}_path" )
      ]
    end

    def plugins_for_edit_capabilities
      ShinyCMS.plugins.with_partial 'admin/user/_edit_capabilities.html.erb'
    end

    def capability( name:, category: )
      ShinyCMS::Capability.readonly.find_by( name: name, category: category )
    end

    def capability_category( name )
      ShinyCMS::CapabilityCategory.readonly.find_by( name: name.to_s )
    end

    def render_capability_category( form, category, capabilities, show )
      render partial: 'capability_category', locals: {
        f:                     form,
        category:              category,
        category_capabilities: capabilities,
        show:                  show
      }
    end

    def render_capability_checkbox( form, capability, capability_category )
      return if capability == 'skip'

      render partial: 'capability_checkbox', locals: {
        f:          form,
        capability: capability,
        category:   capability_category
      }
    end
  end
end
