# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Base model class for ShinyProfiles plugin for ShinyCMS
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
