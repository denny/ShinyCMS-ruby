FactoryBot.define do
  factory :page_template do
    name     { Faker::Science.unique.scientist }
    filename { 'example' }
  end

  factory :page_template_with_elements, parent: :page_template do
    name     { Faker::Science.unique.scientist }
    filename { 'example' }

    after :create do |template|
      create_list :page_template_element, 3, template: template
    end
  end
end
