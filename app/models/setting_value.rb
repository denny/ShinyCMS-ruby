# Model class for setting values (site-wide and per-user config settings)
class SettingValue < ApplicationRecord
  belongs_to :setting, inverse_of: 'values'
end
