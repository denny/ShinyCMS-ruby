# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Load locale files from any plugins
I18n.load_path += Rails.root.glob( 'plugins/*/config/locales/*.yml' )

# Set the available locales
I18n.available_locales = %i[ en ]

# Set the default locale
I18n.default_locale = :en

# TODO: Add Spanish. Add American. Explicitly label English and American.
# config.i18n.available_locales = %i[ en-GB en-US es ]
# Set the default locale
# config.i18n.default_locale = :'en-GB'
# If the user's current locale is missing a translation, try these other locales
# I18n.fallbacks = %i[ en-GB en en-US ]
