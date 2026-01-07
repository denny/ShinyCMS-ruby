# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Model class for template elements - part of the ShinyPages plugin for ShinyCMS
  class TemplateElement < ApplicationRecord
    include ShinyCMS::TemplateElement

    include ShinyCMS::ProvidesDemoSiteData
  end
end
