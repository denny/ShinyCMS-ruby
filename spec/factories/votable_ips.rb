# frozen_string_literal: true

FactoryBot.define do
  factory :votable_ip do
    ip_address { Faker::Internet.unique.ip_v4_address }
  end
end
