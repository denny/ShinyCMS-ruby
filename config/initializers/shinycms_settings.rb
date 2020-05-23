# frozen_string_literal: true

# Stuff that has to be set before we're up and running
Rails.application.config.multiple_blogs_mode =
  ENV['SHINYCMS_MULTIPLE_BLOGS_MODE'].present?
