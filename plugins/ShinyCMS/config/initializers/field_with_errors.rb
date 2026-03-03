# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Set the 'field_with_errors' class on the input tag instead of wrapping it in a div
ActionView::Base.field_error_proc =
  proc do |html_tag, _instance|
    if html_tag.match?( %r{class=['"][^'"]+['"]} )
      # :nocov:
      html_tag.sub( %r{class=['"]([^'"]+)['"]}, 'class="\1 field_with_errors"' ).html_safe
      # :nocov:
    elsif html_tag.include?( ' />' )
      html_tag.sub( '/>', 'class="field_with_errors" />' ).html_safe
    else
      parts = html_tag.split( '>', 2 )
      # rubocop:disable Style/ArrayFirstLast
      parts[0] += ' class="field_with_errors">'
      # rubocop:enable Style/ArrayFirstLast
      ( parts.first + parts.second ).html_safe
    end
  end
