# frozen_string_literal: true

# Part of the Pundit-powered ACL - group capabilities by site area, e.g. :pages
class CapabilityCategory < ApplicationRecord
  has_many :capabilities, inverse_of: :category, foreign_key: :category_id,
                          dependent: :restrict_with_error
end
