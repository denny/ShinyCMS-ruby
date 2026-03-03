# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Configure which spec files the Rails generators should create

Rails.application.config.generators do |conf|
  conf.test_framework   :rspec
  conf.model_specs      true
  conf.view_specs       false
  conf.controller_specs false
  conf.request_specs    true
  conf.helper_specs     true
  conf.routing_specs    false
end
