# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Seed data for capabilities (used by user authorisation code)

def add_capabilities( capability_data )
  capability_data.each_key do |category_name|
    category = CapabilityCategory.find_or_create_by!( name: category_name )

    capability_data[ category_name ].each do |capability_name|
      category.capabilities.find_or_create_by( name: capability_name )
    end
  end
end

add_capabilities(
  {
    general:          %w[ view_admin_area view_admin_toolbar manage_sidekiq_jobs ],
    discussions:      %w[ show hide lock unlock ],
    comments:         %w[ show hide lock unlock destroy ],
    spam_comments:    %w[ list add destroy ],
    email_recipients: %w[ list edit destroy ],
    mailer_previews:  %w[ list show ],
    stats:            %w[ view_web view_email view_charts make_charts ],
    feature_flags:    %w[ list edit ],
    settings:         %w[ list edit ],
    consent_versions: %w[ list add edit destroy ],
    users:            %w[ list add edit destroy view_admin_notes ],
    admin_users:      %w[ list add edit destroy ]
  }
)
