FactoryBot.define do
  factory :consent do
    purpose_type { 'Subscription' }
    purpose_id { 1 }
    action { 'checkbox' }
    wording { 'I would like to receive email relating to any and all of the lists I have checked above' }
    url { 'https://example.com/lists' }
  end
end
