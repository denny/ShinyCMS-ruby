# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

Ckeditor.setup do |config|
  # //cdn.ckeditor.com/<version.number>/<distribution>/ckeditor.js
  config.cdn_url = '//cdn.ckeditor.com/4.6.1/full/ckeditor.js'
  # This will enforce authentication/authorisation
  config.parent_controller = 'ShinyCMS::AdminController'
end
