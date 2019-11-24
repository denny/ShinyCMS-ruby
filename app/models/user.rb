# User model - Devise powered
class User < ApplicationRecord
  # Allowed characters for usernames: a-z A-Z 0-9 . _ -
  USERNAME_REGEX = %r{[-_\.a-zA-Z0-9]+}.freeze
  public_constant :USERNAME_REGEX
  ANCHORED_USERNAME_REGEX = %r{\A#{USERNAME_REGEX}\z}.freeze
  private_constant :ANCHORED_USERNAME_REGEX

  # Include default and most extra devise modules. Only :omniauthable not used.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
  devise :pwned_password unless Rails.env.test?

  # Validations for username field
  validates :username, presence:   true
  validates :username, uniqueness: true, case_sensitive: false
  validates :username, length:     { maximum: 50 }
  # Restrict the character set for usernames to letters, numbers, and - . _
  validates :username, format: ANCHORED_USERNAME_REGEX

  # Configure default count-per-page for pagination
  paginates_per 20

  # Virtual attribute to allow authenticating by either username or email
  attr_writer :login
  def login
    @login || username || email
  end

  # Queue email sends
  def send_devise_notification( notification, *args )
    # :nocov:
    devise_mailer.public_send( notification, self, *args ).deliver_later
    # :nocov:
  end

  # Override find method to search by username as well as email
  def self.find_first_by_auth_conditions( warden_conditions )
    conditions = warden_conditions.dup
    login = conditions.delete( :login )
    where_clause = 'lower( username ) = :value OR lower( email ) = :value'
    where( conditions ).find_by( [ where_clause, { value: login.downcase } ] )
  end
end
