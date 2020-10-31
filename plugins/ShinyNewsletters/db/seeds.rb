# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# You can load or reload this data using the following rake task:
# rails shiny_newsletters:db:seed

# Feature flag

flag = FeatureFlag.find_or_create_by!( name: 'newsletters' )
flag.update!(
  description: 'Enable newsletter features (provided by ShinyNewsletters plugin)',
  enabled: true,
  enabled_for_logged_in: true,
  enabled_for_admins: true
)

# Admin capabilities

def add_capabilities( capability_data )
  capability_data.each_key do |category_name|
    category = CapabilityCategory.create_or_find_by!( name: category_name )

    capability_data[ category_name ].each do |capability_name|
      category.capabilities.create_or_find_by( name: capability_name )
    end
  end
end

# rubocop:disable Layout/HashAlignment
add_capabilities(
  {
    newsletter_templates: %w[ list add edit destroy ],
    newsletter_editions:  %w[ list add edit destroy ],
    newsletter_sends:     %w[ list add edit destroy ]
  }
)
# rubocop:enable Layout/HashAlignment
