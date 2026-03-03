# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'shiny_seo/engine'

# Namespace wrapper
module ShinySEO
  ENV['CONFIG_FILE'] ||= 'plugins/ShinySEO/config/sitemap.rb'

  spec = Gem::Specification.find_by_name 'sitemap_generator'
  load "#{spec.gem_dir}/lib/tasks/sitemap_generator_tasks.rake"
end
