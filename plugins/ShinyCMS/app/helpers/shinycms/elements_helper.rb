# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helpers for code dealing with Page/Template/etc elements
  module ElementsHelper
    # Provide list of known element types (short text, long text, etc) for use in drop-down menus
    def element_types
      I18n.t( 'shinycms.admin.elements' ).collect { |element| [ element.second, element.first ] }
    end
  end
end
