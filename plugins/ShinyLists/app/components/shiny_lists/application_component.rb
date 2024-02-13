# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Base class for view components - part of the ShinyLists plugin for ShinyCMS
  class ApplicationComponent < ViewComponent::Base
    include ShinyCMS::ViewComponentBase
  end
end
