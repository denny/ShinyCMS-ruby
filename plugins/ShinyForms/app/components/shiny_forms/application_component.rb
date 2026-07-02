# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Base class for view components - part of the ShinyForms plugin for ShinyCMS
  class ApplicationComponent < ViewComponent::Base
    include ShinyCMS::ViewComponentBase
  end
end
