# frozen_string_literal: true

# Class for settings items (definitions)
class Setting < ApplicationRecord
  # Error class
  class CannotUpdateLockedSetting < StandardError; end

  validates :name,   presence: true
  validates :level,  presence: true
  validates :locked, inclusion: { in: [ true, false ] }

  validate :validate_not_locked, on: %i[ update destroy ]

  has_many :values, class_name: 'SettingValue', inverse_of: 'setting',
                    dependent: :destroy

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
    return unless locked

    raise CannotUpdateLockedSetting, 'Attempted to update a locked setting'
  end
end
