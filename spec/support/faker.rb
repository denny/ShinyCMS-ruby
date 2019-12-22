# Configure Faker to reset the uniqueness generators between each test
RSpec.configure do |config|
  config.before :each do
    Faker::UniqueGenerator.clear
    Faker::Lorem.unique.exclude :word, nil, %w[ sed ut ]
  end
end
