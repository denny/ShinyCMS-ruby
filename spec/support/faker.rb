# Configure Faker to reset the uniqueness generators between each test
RSpec.configure do |config|
  config.before :each do
    Faker::UniqueGenerator.clear
  end
end
