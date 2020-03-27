# Model for mailing list subscriptions
class Subscription < ApplicationRecord
  validates :subscriber, presence: true
  validates :list,       presence: true

  belongs_to :subscriber, inverse_of: :subscriptions, polymorphic: true
  belongs_to :list,       inverse_of: :subscriptions, class_name: 'MailingList'

  has_one :consent, inverse_of: :purpose, dependent: :destroy
end
