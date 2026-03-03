# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper methods for admin area
  module AdminAreaHelper
    include ShinyCMS::DatesHelper
    include ShinyCMS::ElementsHelper
    include ShinyCMS::PluginsHelper
    include ShinyCMS::UsersHelper
    include ShinyCMS::ViewComponentHelper

    def shinycms_admin_controller?
      controller.class.include? ShinyCMS::AdminAreaControllerBase
    end

    def shinycms_version
      ShinyCMS::VERSION
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
