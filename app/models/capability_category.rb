# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Part of the Pundit-powered ACL - group capabilities by site area, e.g. :pages
class CapabilityCategory < ApplicationRecord
  include ShinySoftDelete

  # Associations

  has_many :capabilities, inverse_of: :category, foreign_key: :category_id, dependent: :restrict_with_error

  # Class methods

  # Returns the name of the capability category for a model instance, as a symbol
  # Logs an error and returns nil if there is no corresponding category in the database
  def self.name_for( record )
    name = category_name_for( record )

    return name.to_sym if category_names.include? name

    Rails.logger.warn I18n.t( 'models.capability_category.not_found', name: name )
    nil
  end

  def self.category_name_for( record )
    record = record.class unless record.is_a? Class

    return record.capability_category_name if record.respond_to? :capability_category_name

    record.name.underscore.pluralize.tr( '/', '_' )
  end

  def self.category_names
    @category_names ||= pluck( :name )
  end
end
