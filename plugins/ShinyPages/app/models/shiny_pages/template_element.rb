# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Model class for template elements
  class TemplateElement < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyElement

    belongs_to :template, inverse_of: :elements

    validates :template, presence: true

    acts_as_list scope: :template
  end
end
