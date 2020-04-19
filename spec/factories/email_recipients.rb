# frozen_string_literal: true

FactoryBot.define do
  factory :email_recipient do
    name  { Faker::Books::CultureSeries.unique.culture_ship }
    email { Faker::Internet.unique.email }
  end
end
