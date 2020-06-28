# frozen_string_literal: true

# Model for mailing lists
class MailingList < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers,   through: :subscriptions

  validates :name, presence: true
end
