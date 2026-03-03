# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Seed data for capabilities (used by user authorisation code)

require 'shinycms/seeder'

seeder = ShinyCMS::Seeder.new

seeder.seed_standard_admin_capabilities( category: :consent_versions )
seeder.seed_standard_admin_capabilities( category: :admin_users      )

# Most of the capabilities to be set here are not the standard four, so ...
class ShinyCMS::CapabilitySetup
  def add( capability_data )
    capability_data.each_key do |category_name|
      category = ShinyCMS::CapabilityCategory.find_or_create_by!( name: category_name )

      capability_data[ category_name ].each do |capability_name|
        category.capabilities.find_or_create_by( name: capability_name )
      end
    end
  end
end

ShinyCMS::CapabilitySetup.new.add(
  {
    general:          %w[ view_admin_area view_admin_toolbar ],
    tools:            %w[ use_blazer use_coverband use_letter_opener_web use_rails_email_preview use_sidekiq_web ],
    discussions:      %w[ show hide lock unlock ],
    comments:         %w[ show hide lock unlock destroy ],
    spam_comments:    %w[ list add destroy ],
    email_recipients: %w[ list edit destroy ],
    mailer_previews:  %w[ list show ],
    stats:            %w[ view_web view_email ],
    feature_flags:    %w[ list edit ],
    settings:         %w[ list edit ],
    users:            %w[ list add edit destroy view_admin_notes ]
  }
)
