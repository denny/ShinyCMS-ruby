# Model for mailing list subscribers who aren't authenticated users
class Subscriber < ApplicationRecord
  validates :name,  presence: true
  validates :email, presence: true
  validates :email, uniqueness: true, case_sensitive: false
  validates_with EmailAddress::ActiveRecordValidator
  validates :token, presence: true
  validates :token, uniqueness: true

  has_many :subscriptions, inverse_of: :subscriber, dependent: :destroy

  before_validation :generate_token, if: -> { token.blank? }

  private

  def generate_token
    self.token = SecureRandom.uuid
  end
end
