# frozen_string_literal: true

# Part of the Pundit-powered ACL - a capability is a thing that a user can do
class Capability < ApplicationRecord
  belongs_to :category, inverse_of: :capabilities, class_name: 'CapabilityCategory'

  has_many :user_capabilities, inverse_of: :capability, dependent: :restrict_with_error

  has_many :users, inverse_of: :capabilities, through: :user_capabilities,
                   dependent: :restrict_with_error
end
