FactoryBot.define do
  factory :page, aliases: [ :top_level_page ] do
    name   { Faker::Books::CultureSeries.unique.culture_ship }
    title  { name.dup.titlecase }
    slug   { name.dup.parameterize }
    hidden { false }
    association :template, factory: :page_template

    trait :hidden do
      hidden { true }
    end
  end

  factory :page_in_section, parent: :page do
    association :section, factory: :page_section
  end

  factory :page_in_subsection, parent: :page do
    association :section, factory: :page_subsection
  end

  factory :page_with_one_of_each_element_type, parent: :page do
    after :create do |page|
      create :short_text_page_element, page: page, content: 'SHORT!'
      create :long_text_page_element,  page: page, content: 'LONG!'
      create :image_page_element,      page: page, content: 'IMAGE.png'
      create :html_page_element,       page: page, content: 'HTML!'
    end
  end
end
