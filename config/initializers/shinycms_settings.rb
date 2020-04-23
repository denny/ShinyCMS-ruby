# frozen_string_literal: true

# Stuff that has to be set before we're up and running
if ENV['SHINYCMS_MULTIPLE_BLOGS_MODE'].present?
  # :nocov:
  Rails.application.config.multiple_blogs_mode = true
  # :nocov:
else
  Rails.application.config.multiple_blogs_mode = false
end
