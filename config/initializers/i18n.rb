# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Load locale files from any plugins
I18n.load_path += Dir[ Rails.root.join( 'plugins/*/config/locales/*.yml' ) ]

# Set the available locales
I18n.available_locales = %i[ en ]

# Set the default locale
I18n.default_locale = :en

# TODO: Add Spanish. Add American. Explicitly label English and American.
# config.i18n.available_locales = %i[ en-GB en-US es ]
# config.i18n.default_locale = :'en-GB'
