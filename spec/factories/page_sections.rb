FactoryBot.define do
  factory :page_section do
    name   { 'Test Section' }
    title  { 'Test Section' }
    slug   { 'test_section' }
    hidden { false }
  end
end
