# frozen_string_literal: true

# Part of the Pundit-powered ACL - group capabilities by type, e.g. 'Pages'
class CapabilityCategory < ApplicationRecord
  has_many :capabilities, foreign_key: 'category_id',
                          inverse_of: 'category',
                          dependent: :restrict_with_error
end
