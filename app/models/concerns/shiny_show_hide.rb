# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Common behaviour for models that can be shown/hidden on the site, on site menus, etc
module ShinyShowHide
  extend ActiveSupport::Concern

  included do
    # Validations

    # rubocop:disable Style/RedundantSelf
    validates :show_on_site,  inclusion: { in: [ true, false ] }
    validates :show_in_menus, inclusion: { in: [ true, false ] } if self.respond_to?( :show_in_menus )
    # rubocop:enable Style/RedundantSelf

    # Scopes

    scope :visible,          -> { where( show_on_site: true ) }
    scope :visible_in_menus, -> { where( show_on_site: true, show_in_menus: true ) }

    # Instance methods

    def show
      update( show_on_site: true )
    end

    def hide
      update( show_on_site: false )
    end

    def hidden?
      !show_on_site?
    end
  end
end
