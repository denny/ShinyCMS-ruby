# frozen_string_literal: true

# Part of the Pundit-powered ACL - group capabilities by site area, e.g. :pages
class CapabilityCategory < ApplicationRecord
  has_many :capabilities, inverse_of: :category, foreign_key: :category_id,
                          dependent: :restrict_with_error

  # Class methods

  # Returns the name of the capability category for a model instance, as a symbol
  def self.name_for( record )
    names = record.class.name.underscore.pluralize.split('/')
    name = names.last

    Rails.logger.debug "CapabilityCategory.name_for returned '#{name}' which doesn't exist" unless exists?( name: name )

    name.to_sym
  end
end
