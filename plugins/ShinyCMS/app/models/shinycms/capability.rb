# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Part of the Pundit-powered ACL - a capability is a thing that a user can do
  class Capability < ApplicationRecord
    include ShinyCMS::SoftDelete

    # Associations

    belongs_to :category, inverse_of: :capabilities, class_name: 'CapabilityCategory'

    has_many :user_capabilities, inverse_of: :capability, dependent: :restrict_with_error

    has_many :users, inverse_of: :capabilities, through: :user_capabilities, dependent: :restrict_with_error

    # Class methods

    def self.find_by( **args )
      # Allow shorthand lookup by passing in capability and category names
      if args.keys == %i[ capability category ]
        CapabilityCategory.find_by( name: args[ :category   ] ).capabilities
                          .find_by( name: args[ :capability ] )
      else
        super
      end
    end
  end
end
