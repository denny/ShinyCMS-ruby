# frozen_string_literal: true

# Store details of mailing list subscribers who aren't authenticated users
class EmailRecipient < ApplicationRecord
  include ShinyEmail

  # Associations

  has_many :messages, class_name: 'Ahoy::Message', as: :user, dependent: :nullify

  has_many :subscriptions, inverse_of: :subscriber, dependent: :destroy
  has_many :lists, through: :subscriptions

  # Validations

  validates :name,  presence: true
  validates :token, presence: true, uniqueness: true

  # Before/after actions

  before_validation :generate_token, if: -> { token.blank? }

  # Class methods

  def self.dump_for_demo?
    true
  end

  private

  def generate_token
    self.token = SecureRandom.uuid
  end
end
