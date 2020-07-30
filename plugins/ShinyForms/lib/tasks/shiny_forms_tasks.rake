# frozen_string_literal: true

# ShinyForms: ShinyCMS forms plugin

require 'dotenv/tasks'

namespace :shiny do
  namespace :forms do
    # :nocov:
    desc 'ShinyCMS: install data and migrations for Forms plugin'
    task list: %i[ environment dotenv ] do
      # Add form admin capabilities (for user authorisation)
      forms_cc = CapabilityCategory.find_or_create_by!( name: 'forms' )
      forms_cc.capabilities.find_or_create_by!( name: 'list'    )
      forms_cc.capabilities.find_or_create_by!( name: 'add'     )
      forms_cc.capabilities.find_or_create_by!( name: 'edit'    )
      forms_cc.capabilities.find_or_create_by!( name: 'destroy' )

      # Add feature flag for forms
      FeatureFlag.find_or_create_by!( name: 'forms' )
                 .update!(
                   description: 'Form handlers',
                   enabled: true,
                   enabled_for_logged_in: true,
                   enabled_for_admins: true
                 )

      # TODO: move migrations from plugin tree to core tree
    end
    # :nocov:
  end
end
