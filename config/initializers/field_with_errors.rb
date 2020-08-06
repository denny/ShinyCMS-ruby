# frozen_string_literal: true

# Set the 'field_with_errors' class on the input tag instead of wrapping it in a div
ActionView::Base.field_error_proc =
  proc do |html_tag, _instance|
    parts = html_tag.split('>', 2)
    parts[0] += ' class="field_with_errors">'
    (parts[0] + parts[1]).html_safe
  end
