# Toggle feature flags
namespace :feature do
  desc 'Toggle a feature flag on'
  task :on, [ :name ] => [ :environment ] do |_t, args|
    FeatureFlag.find_by( name: args[:name].downcase ).update!( enabled: true )
    puts "Set enabled=true for #{args[:name]}"
  end

  desc 'Toggle a feature flag off'
  task :off, [ :name ] => [ :environment ] do |_t, args|
    FeatureFlag.find_by( name: args[:name].downcase ).update!( enabled: false )
    puts "Set enabled=false for #{args[:name]}"
  end
end
