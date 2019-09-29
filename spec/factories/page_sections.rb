FactoryBot.define do
  factory :page_section do
    name { "MyString" }
    description { "MyText" }
    title { "MyString" }
    slug { "MyString" }
    section_id { 1 }
    sort_order { 1 }
    hidden { false }
    last_published_at { "2019-09-28 10:13:01" }
  end
end
