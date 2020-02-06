# Class for settings items (definitions)
class Setting < ApplicationRecord
  validates :name, presence: true
  validates :level, presence: true
  validates :locked, presence: true

  has_many :values, class_name: 'SettingValue',
                    inverse_of: 'setting',
                    dependent: :destroy

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

  def self.get( name )
    # TODO: user/admin settings
    find_by( name: name.to_s )&.site_value
  end
end
