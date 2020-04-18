# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    subscriber_type { 'EmailRecipient' }
  end
end
