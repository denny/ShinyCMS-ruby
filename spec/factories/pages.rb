FactoryBot.define do
  factory :page do
    name   { 'Test Page' }
    title  { 'Test Page' }
    slug   { 'test_page' }
    hidden { false }
    template_id { 1 }
    hidden { false }
  end
end
