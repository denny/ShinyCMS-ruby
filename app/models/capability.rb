# Part of the Pundit-powered ACL - a capability is a thing that a user can do
class Capability < ApplicationRecord
  belongs_to :category, class_name: 'CapabilityCategory',
                        inverse_of: 'capabilities'

  has_many :user_capabilities, inverse_of: 'capability',
                               dependent: :restrict_with_error

  has_many :users, inverse_of: 'capabilities',
                   through: :user_capabilities,
                   dependent: :restrict_with_error
end
