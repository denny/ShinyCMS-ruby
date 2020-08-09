# frozen_string_literal: true

# User model (powered by Devise)
# rubocop:disable Metrics/ClassLength
class User < ApplicationRecord
  include ShinyEmail

  # Associations

  # Authorisation (powered by Pundit)
  has_many :user_capabilities, dependent: :destroy
  has_many :capabilities, through: :user_capabilities, inverse_of: :users

  # Web and email stats (powered by Ahoy and Ahoy::Email)
  has_many :visits, class_name: 'Ahoy::Visit', dependent: :nullify
  has_many :messages, class_name: 'Ahoy::Message', dependent: :nullify

  # User's custom site settings, if any
  has_many :settings, class_name: 'SettingValue', inverse_of: :user, dependent: :destroy

  # TODO: polymorphic relationship here so users can own any type of plugin-provided content

  # End-user content: destroy it along with their account
  has_many :comments, dependent: :destroy
  has_many :subscriptions, as: :subscriber, dependent: :destroy
  has_many :lists, through: :subscriptions

  # Admin content: throw an error if it hasn't been removed or reassigned
  has_many :blogs,      dependent: :restrict_with_error
  has_many :blog_posts, dependent: :restrict_with_error

  # Validations

  # Allowed characters for usernames: a-z A-Z 0-9 . _ -
  USERNAME_REGEX = %r{[-_.a-zA-Z0-9]+}.freeze
  public_constant :USERNAME_REGEX
  ANCHORED_USERNAME_REGEX = %r{\A#{USERNAME_REGEX}\z}.freeze
  private_constant :ANCHORED_USERNAME_REGEX

  validates :username, presence: true, uniqueness: true, case_sensitive: false
  validates :username, length: { maximum: 50 }
  validates :username, format: ANCHORED_USERNAME_REGEX

  # Plugins

  # Enable basically every Devise module except :omniauthable (for now)
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :lockable, :timeoutable, :trackable
  devise :pwned_password unless Rails.env.test?

  acts_as_voter

  paginates_per 20

  # Virtual attributes

  # User profile pic (powered by ActiveStorage)
  has_one_attached :profile_pic

  # Allow authenticating by either username or email
  attr_writer :login

  def login
    @login || username || email
  end

  # Instance methods

  def admin?
    general = CapabilityCategory.find_by( name: 'general' )
    capabilities.exists? name: 'view_admin_area', category: general
  end

  def not_admin?
    !admin?
  end

  def can?( capability_name, category_name = :general )
    return cached_can?( capability_name, category_name ) if @cached_capabilities.present?

    cc = CapabilityCategory.find_by( name: category_name.to_s )
    return true if capabilities.exists? name: capability_name.to_s, category: cc

    false
  end

  def cached_can?( capability, category = :general )
    return false if cached_capabilities.blank?

    return true if cached_capabilities[ category.to_s ]&.include? capability.to_s

    false
  end

  def cached_capabilities
    return @cached_capabilities if @cached_capabilities.present?

    @cached_capabilities =
      capabilities.joins( :category )
                  .pluck( 'capability_categories.name', :name )
                  .group_by( &:shift )
                  .each_value( &:flatten! )
  end

  def cache_capabilities
    cached_capabilities if @cached_capabilities.blank?
    self
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

  def grant_all_capabilities
    User.transaction do
      Capability.all.find_each do |capability|
        user_capabilities.find_or_create_by! capability: capability
      end
    end
    self
  end

  def display_name_or_username
    display_name.presence || username
  end

  # Queue email sends
  def send_devise_notification( notification, *args )
    devise_mailer.public_send( notification, self, *args ).deliver_later
  end

  def primary_admin_area
    return unless admin?

    # List of admin areas, approximately in order of 'most commonly used'
    # (used by /admin index method to redirect somewhere hopefully useful)
    areas = %i[ pages blogs blog users settings shiny_forms_forms ]

    areas.each do |area|
      return area if can? :list, area
    end
    nil
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

  # Check whether we have at least one admin who can create more admins
  def self.super_admins_exist?
    that_can( :add, :admin_users ).present?
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
# rubocop:enable Metrics/ClassLength
