# Turn ShinyCMS feature flags on/off

# rails shiny:feature:on  - turns a feature on  (for all user types)
# rails shiny:feature:off - turns a feature off (for all user types)

namespace :shiny do
  namespace :feature do
    desc 'Toggle a feature flag on'
    task :on, [ :name ] => [ :environment ] do |_t, args|
      flag = FeatureFlag.enable args[:name]
      puts "Set enabled=true for #{args[:name]}" if flag.valid?
    end

    desc 'Toggle a feature flag off'
    task :off, [ :name ] => [ :environment ] do |_t, args|
      flag = FeatureFlag.disable args[:name]
      puts "Set enabled=false for #{args[:name]}" if flag.valid?
    end
  end
end
