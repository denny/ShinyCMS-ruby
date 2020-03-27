# Store details of mailing list subscribers who aren't authenticated users
class EmailRecipient < ApplicationRecord
  include Email

  validates :name,  presence: true
  validates :token, presence: true, uniqueness: true

  has_many :subscriptions, inverse_of: :subscriber, dependent: :destroy
  has_many :lists, through: :subscriptions

  before_validation :generate_token, if: -> { token.blank? }

  private

  def generate_token
    self.token = SecureRandom.uuid
  end
end
