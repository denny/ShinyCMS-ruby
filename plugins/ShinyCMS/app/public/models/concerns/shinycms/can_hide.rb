# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for models that can be shown/hidden on the site, on site menus, etc
  module CanHide
    extend ActiveSupport::Concern

    included do
      validates :show_on_site,  inclusion: { in: [ true, false ] }

      scope :visible,          -> { where( show_on_site: true  ) }
      scope :hidden,           -> { where( show_on_site: false ) }
      scope :visible_in_menus, -> { where( show_on_site: true, show_in_menus: true ) }

      def show
        update( show_on_site: true )
      end

      def hide
        update( show_on_site: false )
      end

      def visible?
        show_on_site?
      end

      def hidden?
        !show_on_site?
      end
    end
  end
end
