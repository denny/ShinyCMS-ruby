# Stuff that has to be set before we're up and running
if ENV['SHINYCMS_MULTIPLE_BLOGS_MODE'].present?
  Rails.application.config.multiple_blogs_mode = true
else
  Rails.application.config.multiple_blogs_mode = false
end
