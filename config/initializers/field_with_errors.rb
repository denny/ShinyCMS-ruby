# frozen_string_literal: true

# Set the 'field_with_errors' class on the input tag instead of wrapping it in a div
ActionView::Base.field_error_proc =
  proc do |html_tag, _instance|
    if html_tag.match?( %r{class=['"][^'"]+['"]} )
      html_tag.sub( %r{class=['"]([^'"]+)['"]}, 'class="\1 field_with_errors"' ).html_safe
    elsif html_tag.include?( ' />' )
      html_tag.sub( '/>', 'class="field_with_errors" />' ).html_safe
    else
      parts = html_tag.split( '>', 2 )
      parts[0] += ' class="field_with_errors">'
      (parts[0] + parts[1]).html_safe
    end
  end
