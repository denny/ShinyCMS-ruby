# Model class for setting values (site-wide and per-user config settings)
class SettingValue < ApplicationRecord
  validates :setting_id, presence: true
  validates :user_id,    uniqueness: {
    scope: :setting,
    message: I18n.t( 'models.setting_value.one_per_user' )
  }

  belongs_to :setting, inverse_of: 'values'
  belongs_to :user,    inverse_of: 'settings', optional: true

  # Instance methods

  # Pairs with Setting.set to give you Setting.set( :foo ).to( 'bar' )
  def to( new_value )
    update!( value: new_value )
  end
end
