# frozen_string_literal: true

# ShinyForms: ShinyCMS forms plugin
#
# To install supporting data for Forms (admin capabilities and feature flag):
# rails shiny_forms:install:data
#
# To copy and run the database migrations for Forms:
# rails shiny_forms:install:migrations
# rails db:migrate
#
# These two tasks can be run in either order. You will need to do both, in all environments.

require 'dotenv/tasks'

namespace :shiny_forms do
  namespace :install do
    # :nocov:
    desc 'ShinyCMS: install supporting data for Forms plugin'
    task data: %i[ environment dotenv ] do
      # Add admin capabilities for Forms plugin
      forms_cc = CapabilityCategory.find_or_create_by!( name: 'forms' )
      forms_cc.capabilities.find_or_create_by!( name: 'list'    )
      forms_cc.capabilities.find_or_create_by!( name: 'add'     )
      forms_cc.capabilities.find_or_create_by!( name: 'edit'    )
      forms_cc.capabilities.find_or_create_by!( name: 'destroy' )

      # Add feature flag for Forms plugin
      forms_flag = FeatureFlag.find_or_create_by!( name: 'forms' )
      forms_flag.update!(
        description: 'Enable generic form handlers from ShinyForms plugin',
        enabled: true,
        enabled_for_logged_in: true,
        enabled_for_admins: true
      )
    end
    # :nocov:
  end
end
