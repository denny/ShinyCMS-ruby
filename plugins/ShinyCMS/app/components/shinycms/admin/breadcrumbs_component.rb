# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Component to render the admin area breadcrumbs
    class BreadcrumbsComponent < ApplicationComponent
      def initialize( page_title:, controller_name:, controller_class_name:, path: nil )
        plugin_name = controller_class_name.split( '::' ).first

        @section_text = section_text( plugin_name, controller_name )
        @section_path = path || section_path( plugin_name, controller_name )

        @page_title = page_title
      end

      def section_text( plugin_name, controller_name )
        case plugin_name
        when 'RailsEmailPreview'
          t( 'shinycms.admin.rails_email_preview.breadcrumb' )
        when 'Blazer'
          t( 'shinycms.admin.blazer.breadcrumb' )
        else
          t( "#{plugin_name.underscore}.admin.#{controller_name}.breadcrumb" )
        end
      end

      def section_path( plugin_name, controller_name )
        ShinyCMS::Plugin.get( plugin_name ).url_helpers.public_send( "#{controller_name}_path" )
      end
    end
  end
end
