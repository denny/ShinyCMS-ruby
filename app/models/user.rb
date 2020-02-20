# User model (powered by Devise)
class User < ApplicationRecord
  # Include default and most extra devise modules
  # (Only :omniauthable not currently used)
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
  devise :pwned_password unless Rails.env.test?

  # Allowed characters for usernames: a-z A-Z 0-9 . _ -
  USERNAME_REGEX = %r{[-_\.a-zA-Z0-9]+}.freeze
  public_constant :USERNAME_REGEX
  ANCHORED_USERNAME_REGEX = %r{\A#{USERNAME_REGEX}\z}.freeze
  private_constant :ANCHORED_USERNAME_REGEX

  # Validations for username field
  validates :username, presence:   true
  validates :username, uniqueness: true, case_sensitive: false
  validates :username, length:     { maximum: 50 }
  validates :username, format:     ANCHORED_USERNAME_REGEX

  # User profile pic (powered by ActiveStorage)
  has_one_attached :profile_pic

  # Authorisation (powered by Pundit)
  has_many :user_capabilities, inverse_of: 'user',
                               dependent: :restrict_with_error
  has_many :capabilities,      inverse_of: 'users',
                               through: :user_capabilities,
                               dependent: :restrict_with_error

  # "Content, content, content..."
  has_many :blogs,      inverse_of: 'owner',
                        dependent: :restrict_with_error
  has_many :blog_posts, inverse_of: 'author',
                        dependent: :restrict_with_error

  # Configure default count-per-page for pagination
  paginates_per 20

  # Virtual attribute to allow authenticating by either username or email
  attr_writer :login
  def login
    @login || username || email
  end

  # Instance methods

  def can?( capability_name, category_name = :general )
    cc = CapabilityCategory.find_by( name: category_name.to_s )
    return true if capabilities.exists? name: capability_name.to_s, category: cc

    Rails.logger.debug  "Capability check failed: '#{username}' " \
                        "cannot '#{capability_name}' '#{category_name}'"
    false
  end

  def admin?
    general = CapabilityCategory.find_by( name: 'general' )
    capabilities.exists? name: 'view_admin_area', category: general
  end

  def capabilities=( capability_set )
    old_capabilities = user_capabilities.pluck( :capability_id ).sort
    new_capabilities = capability_set.keys.map( &:to_i ).sort

    remove = old_capabilities - new_capabilities
    add    = new_capabilities - old_capabilities

    add.each do |capability_id|
      user_capabilities.create!( capability_id: capability_id )
    end

    user_capabilities.where( capability_id: remove ).delete_all
  end

  # Queue email sends
  def send_devise_notification( notification, *args )
    # :nocov:
    devise_mailer.public_send( notification, self, *args ).deliver_later
    # :nocov:
  end

  # Class methods

  # Return all users that have the specified capability
  def self.that_can( capability, category )
    CapabilityCategory.find_by( name: category.to_s )
                      .capabilities
                      .find_by( name: capability.to_s )
                      .user_capabilities
                      .map( &:user )
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
end
