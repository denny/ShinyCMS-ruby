# frozen_string_literal: true

FactoryBot.define do
  factory :mailing_list do
    name { Faker::Books::CultureSeries.unique.culture_ship }
    is_private { false }
  end
end
