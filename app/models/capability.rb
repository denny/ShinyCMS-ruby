# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Part of the Pundit-powered ACL - a capability is a thing that a user can do
class Capability < ApplicationRecord
  include ShinySoftDelete

  # Associations

  belongs_to :category, inverse_of: :capabilities, class_name: 'CapabilityCategory'

  has_many :user_capabilities, inverse_of: :capability, dependent: :restrict_with_error

  has_many :users, inverse_of: :capabilities, through: :user_capabilities, dependent: :restrict_with_error
end
