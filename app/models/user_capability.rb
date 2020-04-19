# frozen_string_literal: true

# Links users and capabilities
class UserCapability < ApplicationRecord
  belongs_to :user
  belongs_to :capability
end
