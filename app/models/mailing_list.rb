# frozen_string_literal: true

# Model for mailing lists
class MailingList < ApplicationRecord
  validates :name,  presence: true

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions
end
