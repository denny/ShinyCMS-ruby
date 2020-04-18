# frozen_string_literal: true

Ckeditor.setup do |config|
  # //cdn.ckeditor.com/<version.number>/<distribution>/ckeditor.js
  config.cdn_url = '//cdn.ckeditor.com/4.6.1/full/ckeditor.js'
  # This will enforce authentication/authorisation
  config.parent_controller = 'AdminController'
end
