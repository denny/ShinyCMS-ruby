# User model - Devise powered
class User < ApplicationRecord
  # Include default and most extra devise modules. Only :omniauthable not used.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
  devise :pwned_password unless Rails.env.test?

  # Validations for username field
  validates :username, presence:   true
  validates :username, uniqueness: true
  # Restrict the character set for usernames to letters, numbers, and - . _
  validates :username, format: /\A[-_\.a-zA-Z0-9]+\z/

  # Virtual attribute to allow authenticating by either username or email
  attr_writer :login
  def login
    @login || username || email
  end

  def to_param
    username
  end

  # Override find method to search by username as well as email
  def self.find_first_by_auth_conditions( warden_conditions )
    conditions = warden_conditions.dup
    login = conditions.delete( :login )
    if login
      where_clause = 'lower( username ) = :value OR lower( email ) = :value'
      where( conditions ).find_by( [ where_clause, { value: login.downcase } ] )
    elsif conditions[ :username ].nil?
      find_by( conditions )
    else
      find_by( username: conditions[ :username ] )
    end
  end

  # Queue email sends
  def send_devise_notification( notification, *args )
    devise_mailer.public_send( notification, self, *args ).deliver_later
  end
end
