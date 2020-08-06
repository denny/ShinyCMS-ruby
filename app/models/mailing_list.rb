# frozen_string_literal: true

# Model for mailing lists
class MailingList < ApplicationRecord
  include ShinyName

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers,   through: :subscriptions

  # Class methods

  def self.dump_for_demo?
    true
  end
end
