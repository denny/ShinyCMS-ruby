FactoryBot.define do
  factory :page do
    name { "MyString" }
    description { "MyText" }
    title { "MyString" }
    slug { "MyString" }
    template_id { 1 }
    section_id { 1 }
    sort_order { 1 }
    hidden { false }
    last_published_at { "2019-09-28 10:01:53" }
  end
end
