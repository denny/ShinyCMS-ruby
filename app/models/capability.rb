# Part of the Pundit-powered ACL - a capability is a thing that a user can do
class Capability < ApplicationRecord
  belongs_to :category, class_name: 'CapabilityCategory',
                        inverse_of: 'capabilities'
end
