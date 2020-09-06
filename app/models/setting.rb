# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Class for settings items (definitions)
class Setting < ApplicationRecord
  # Custom error class
  class CannotUpdateLockedSetting < StandardError; end

  # Associations

  has_many :values, inverse_of: :setting, class_name: 'SettingValue', dependent: :destroy

  # Validations

  validates :name,   presence: true
  validates :level,  presence: true
  validates :locked, inclusion: { in: [ true, false ] }

  validate :validate_not_locked, on: %i[ update destroy ]

  # Before/after actions

  before_update :enforce_locking

  # Instance methods

  def value
    default_setting_value&.value
  end

  def value_for( user )
    return unless user && level

    return if level == 'admin' && user.not_admin?

    values.find_by( user_id: user )&.value
  end

  def default_setting_value
    values.find_by( user_id: nil )
  end

  # Class methods

  def self.set( name, to: )
    setting = find_by!( name: name.to_s )
    setting.default_setting_value&.update!( value: to )
    setting
  end

  def self.get( name, user = nil )
    setting = find_by name: name.to_s
    return if setting.blank?

    user_value = setting.value_for( user ) if user.present?
    return user_value if user_value.present?

    setting.value
  end

  def self.user_settings
    where( level: 'user' ).order( :name )
  end

  def self.admin_settings
    where( level: 'user' ).or( where( level: 'admin' ) ).order( :name )
  end

  private

  def validate_not_locked
    return unless locked?

    errors.add :base, 'Attempted to update a locked setting'
  end

  def enforce_locking
    return unless locked?

    raise CannotUpdateLockedSetting, 'Attempted to update a locked setting'
  end
end
