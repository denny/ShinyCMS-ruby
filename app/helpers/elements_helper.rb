# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Helpers for code dealing with Page/Template/etc elements
module ElementsHelper
  # Provide list of known element types (short text, long text, etc)
  def element_types
    I18n.t( 'admin.elements' ).values
  end

  # Provide filenames for use in select inputs for image elements
  def select_filenames( path = nil )
    path ||= Rails.root.join( 'public/images' )
    filenames = Dir.glob '*?.?*', base: path
    filenames.sort
  end
end
