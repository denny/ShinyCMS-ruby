# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Component to render the admin area breadcrumbs
    class BreadcrumbsComponent < ApplicationComponent
      def initialize( page_title:, controller_name:, plugin_name:, section_path: nil )
        @plugin_name = plugin_name
        @controller_name = controller_name
        @section_path = section_path || section_path( plugin_name, controller_name )

        @page_title = page_title
      end

      def section_text( plugin_name, controller_name )
        t( "#{plugin_name.underscore}.admin.#{controller_name}.breadcrumb" )
      end

      def section_path( plugin_name, controller_name )
        case plugin_name
        when 'RailsEmailPreview'
          plugin_name = 'ShinyCMS'
          controller_name = 'rails_email_preview'
        when 'Blazer'
          plugin_name = 'ShinyCMS'
          controller_name = 'blazer'
        end

        ShinyCMS::Plugin.get( plugin_name ).url_helpers.public_send( :"#{controller_name}_path" )
      end

      def before_render
        @section_text = section_text( @plugin_name, @controller_name )
      end
    end
  end
end
