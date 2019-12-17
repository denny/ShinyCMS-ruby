# Configure Faker to reset the uniqueness generators between each test
RSpec.configure do |config|
  config.before :each do
    Faker::UniqueGenerator.clear
    Faker::Science.unique.exclude :element, nil, [ 'Tin' ]
  end
end
