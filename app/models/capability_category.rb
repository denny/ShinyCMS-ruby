# frozen_string_literal: true

# Part of the Pundit-powered ACL - group capabilities by site area, e.g. :pages
class CapabilityCategory < ApplicationRecord
  has_many :capabilities, inverse_of: :category, foreign_key: :category_id,
                          dependent: :restrict_with_error

  # Class methods

  # Returns the name of the capability category for a model instance, as a symbol
  def self.name_for( record )
    name = record.class.name.underscore.pluralize.split('/').last
    return name.to_sym if exists?( name: name )

    Rails.logger.warn "CapabilityCategory.name_for generated '#{name}', which is not a valid category"
    nil
  end
end
