FactoryBot.define do
  factory :page_section, aliases: [ :top_level_section ] do
    name   { Faker::DcComics.unique.hero }
    title  { name.dup.titlecase }
    slug   { name.dup.downcase.gsub!( /\s+/, '-' ) }
    hidden { false }

    trait :hidden do
      hidden { true }
    end
  end

  factory :page_subsection, parent: :page_section do
    association :section, factory: :page_section
  end
end
