FactoryBot.define do
  factory :shared_element do
    name  { FactoryBot::Science.unique.element }
    type  { I18n.t( 'short_text' )             }
    value { FactoryBot::Science.scientist      }
  end
end
