# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Model class for template elements - part of the ShinyShop plugin for ShinyCMS
  class TemplateElement < ApplicationRecord
    include ShinyCMS::TemplateElement

    include ShinyCMS::ProvidesDemoSiteData
  end
end
