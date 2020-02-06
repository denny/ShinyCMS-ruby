# Class for settings items (definitions)
class Setting < ApplicationRecord
  # Error class
  class CannotUpdateLocked < StandardError; end

  validates :name,   presence: true
  validates :level,  presence: true
  validates :locked, inclusion: { in: [ true, false ] }

  validate :validate_not_locked, on: :update

  has_many :values, class_name: 'SettingValue',
                    inverse_of: 'setting',
                    dependent: :destroy

  before_update :enforce_locking

  # Instance methods

  def site_value
    values.where( user_id: nil ).pick( :value )
  end

  def user_value( user )
    return unless level == 'user'

    values.where( user_id: user.id ).pick( :value )
  end

  def admin_value( user )
    return unless level == 'admin'
    return unless user.can? :view_admin_area

    values.where( user_id: user.id ).pick( :value )
  end

  # Class methods

  def self.get( name, user = nil )
    return unless ( setting = find_by( name: name.to_s ) )

    value = setting.user_value( current_user ) if user.present?
    return value if value.present?

    value = setting.admin_value( current_user ) if user.present?
    return value if value.present?

    setting.site_value
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
