# Class for settings items (definitions)
class Setting < ApplicationRecord
  # Error class
  class CannotUpdateLocked < StandardError; end

  validates :name,   presence: true
  validates :level,  presence: true
  validates :locked, inclusion: { in: [ true, false ] }

  validate :validate_not_locked, on: :update

  has_many :values, class_name: 'SettingValue', inverse_of: 'setting',
                    dependent: :destroy

  before_update :enforce_locking

  # Instance methods

  def setting_value
    values.find_by( user_id: nil )
  end

  def value
    setting_value&.value
  end

  def setting_value_for( user )
    return if level.nil?

    return if level == 'admin' && user.not_admin?

    values.find_by( user_id: user )
  end

  def value_for( user )
    setting_value_for( user )&.value
  end

  # Class methods

  def self.set( name )
    find_by!( name: name.to_s ).setting_value
  end

  def self.get( name, user = nil )
    setting = find_by name: name.to_s
    return if setting.blank?

    value = setting.value_for( user ) if user.present?
    return value if value.present?

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
    return unless locked

    errors.add :base, 'Attempted to update a locked setting'
  end

  def enforce_locking
    return unless locked

    raise CannotUpdateLocked, 'Attempted to update a locked setting'
  end
end
