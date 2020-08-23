# frozen_string_literal: true

# ShinyInserts plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyInserts
  # Model class for Insert Elements - from the ShinyInserts plugin for ShinyCMS
  class Element < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyElement

    belongs_to :set, inverse_of: :elements, class_name: 'ShinyInserts::Set'

    validates :set, presence: true

    # Specify policy class for Pundit
    def policy_class
      ShinyInserts::ElementPolicy
    end
  end
end
