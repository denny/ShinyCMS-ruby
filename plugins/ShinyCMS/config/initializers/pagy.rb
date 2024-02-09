# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

## Pagy initializer file (3.10.0)

# Customize only what you really need and notice that Pagy works without
# any of the following lines. Should you just cherry pick part of this file,
# please maintain the require-order of the extras

## Extras (https://ddnexus.github.io/pagy/extras)

### Backend Extras

# Array extra: https://ddnexus.github.io/pagy/extras/array
require 'pagy/extras/array'

# Countless extra (paginate without any count): https://ddnexus.github.io/pagy/extras/countless
require 'pagy/extras/countless'
# Pagy::DEFAULT[:cycle] = false    # default

# Elasticsearch Rails extra: https://ddnexus.github.io/pagy/extras/elasticsearch_rails
# require 'pagy/extras/elasticsearch_rails'

# Searchkick extra: https://ddnexus.github.io/pagy/extras/searchkick
# require 'pagy/extras/searchkick'

### Frontend Extras

# Bootstrap extra: https://ddnexus.github.io/pagy/extras/bootstrap
# Add nav, nav_js and combo_nav_js helpers and templates for Bootstrap pagination
require 'pagy/extras/bootstrap'

# Bulma extra: https://ddnexus.github.io/pagy/extras/bulma
# require 'pagy/extras/bulma'

# Foundation extra: https://ddnexus.github.io/pagy/extras/foundation
# require 'pagy/extras/foundation'

# Materialize extra: https://ddnexus.github.io/pagy/extras/materialize
# require 'pagy/extras/materialize'

# Semantic extra: https://ddnexus.github.io/pagy/extras/semantic
# require 'pagy/extras/semantic'

# UIkit extra: https://ddnexus.github.io/pagy/extras/uikit
# require 'pagy/extras/uikit'

# Navs extra: https://ddnexus.github.io/pagy/extras/navs
# Add nav_js and combo_nav_js javascript helpers
# Notice: the other frontend extras add their own framework-styled versions,
# so require this extra only if you need the unstyled version
# require 'pagy/extras/navs'

# Multi size var used by the *_nav_js helpers: https://ddnexus.github.io/pagy/extras/navs#steps
# Pagy::DEFAULT[:steps] = { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] }   # example

### Feature Extras

# HTTP Headers extra: http://ddnexus.github.io/pagy/extras/headers
# require 'pagy/extras/headers'
# Pagy::DEFAULT[:headers] = { page: 'Current-Page', items: 'Page-Items', count: 'Total-Count', pages: 'Total-Pages' }

# Support extra: https://ddnexus.github.io/pagy/extras/support
# Extra support for features like: incremental, infinite, auto-scroll pagination
require 'pagy/extras/support'

# Items extra: https://ddnexus.github.io/pagy/extras/items
# Allow the client to request a custom number of items per page with an optional selector UI
require 'pagy/extras/items'
# Pagy::DEFAULT[ :items_param ] = :items    # default
# Pagy::DEFAULT[ :max_items   ] = 100       # default

# Overflow extra: https://ddnexus.github.io/pagy/extras/overflow
# require 'pagy/extras/overflow'
# Pagy::DEFAULT[:overflow] = :empty_page    # default  (other options: :last_page and :exception)

# Metadata (for JS frameworks) extra: https://ddnexus.github.io/pagy/extras/metadata
# require 'pagy/extras/shared'
# require 'pagy/extras/metadata'
# Pagy::DEFAULT[:metadata] = [:scaffold_url, :count, :page, :prev, :next, :last]  # example

# Trim extra: https://ddnexus.github.io/pagy/extras/trim
# Remove page=1 param from links
require 'pagy/extras/trim'

## Pagy Variables (https://ddnexus.github.io/pagy/api/pagy#variables)

# All the Pagy::DEFAULT are set for all the Pagy instances but can be overridden
# per instance by just passing them to Pagy.new or the #pagy controller method

### Instance variables (https://ddnexus.github.io/pagy/api/pagy#instance-variables)

# TODO: pull this from settings, and allow different defaults for main site and admin area
Pagy::DEFAULT[ :items ] = 10

### Other Variables (https://ddnexus.github.io/pagy/api/pagy#other-variables)

Pagy::DEFAULT[ :size ] = [ 3, 3, 3, 3 ]

# Pagy::DEFAULT[:page_param] = :page                           # default
# Pagy::DEFAULT[:params]     = {}                              # default
# Pagy::DEFAULT[:anchor]     = '#anchor'                       # example
# Pagy::DEFAULT[:link_extra] = 'data-remote="true"'            # example

## Rails

# Rails + JavaScript (https://ddnexus.github.io/pagy/extras#javascript)
# Extras assets path required by the helpers that use javascript
# (pagy*_nav_js, pagy*_combo_nav_js, and pagy_items_selector_js)
Rails.application.config.assets.paths << Pagy.root.join( 'javascripts' )

## I18n (https://ddnexus.github.io/pagy/api/frontend#i18n)
### Pagy internal I18n: ~18x faster using ~10x less memory than the i18n gem
# No need to configure anything in this section if your app uses only "en"
# or if you use the standard i18n extra below
#
# Examples:
#
# Load the "en" and "es" built-in locales:
# (the first passed :locale will be used also as the default_locale)
# Pagy::I18n.load( { locale: 'en' }, { locale: 'es' } )
#
# Load the "en" built-in locale, a custom "es" locale,
# and a totally custom locale complete with a custom :pluralize proc:
# (the first passed :locale will be used also as the default_locale)
# Pagy::I18n.load({locale: 'en'},
#                 {locale: 'es', filepath: 'path/to/pagy-es.yml'},
#                 {locale: 'xyz',  # not built-in
#                  filepath: 'path/to/pagy-xyz.yml',
#                  pluralize: lambda{|count| ... } )

## I18n extra (https://ddnexus.github.io/pagy/extras/i18n)
# Uses the standard i18n gem (~18x slower + uses ~10x more memory than pagy's internal i18n)
# require 'pagy/extras/i18n'

# Default i18n key
# Pagy::DEFAULT[:i18n_key] = 'pagy.item_name'
