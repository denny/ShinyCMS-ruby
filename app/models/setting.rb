# Model class for site settings
class Setting < ApplicationRecord
  validates :name, presence: true

  SOUNDS_LIKE_YES = %w[ yes y true on ].freeze
  private_constant :SOUNDS_LIKE_YES

  # Instance methods

  # Return true if a setting has a yes-ish value
  def yes?
    return true if value.downcase == I18n.t( 'yes' ).downcase
    return true if SOUNDS_LIKE_YES.include? value.downcase

    false
  end

  # Class methods

  # Return the value of the specified setting
  def self.get( name )
    where( name: name).pick( :value )
  end

  # Find a setting and then return true if it sounds like a 'yes'
  def self.yes?( name )
    find_by( name: name)&.yes?
  end
end
