# Model for mailing list subscriptions
class Subscription < ApplicationRecord
  validates :mailing_list, presence: true
  validates :subscriber,   presence: true

  belongs_to :subscriber, inverse_of: :subscriptions, polymorphic: true
end
