# ShinySearch: search feature plugin for ShinyCMS

ShinySearch is a plugin for [ShinyCMS](https://shinycms.org) which adds a search feature (with a choice of backend engines) to your ShinyCMS website.


## Installation

Add 'ShinySearch' to the SHINYCMS_PLUGINS ENV var, then run`bundle install` for your main ShinyCMS app.

(Currently, all plugins are enabled by default, so you don't actually need to set the ENV var unless you want to load a subset of plugins.)

To add the ShinySearch tables and supporting data to your ShinyCMS database:
```bash
rails shiny_search:install:migrations
rails db:migrate
rails shiny_search:db:seed
```

## Configuration: Algolia

Agolia is a Search-as-a-Service provider, available free for non-commercial sites. You will need to register for your own API keys, and then add them to your ENV:
```
# https://www.algolia.com/dashboard
ALGOLIASEARCH_APPLICATION_ID=AA99AA99AA
ALGOLIASEARCH_API_KEY=9999aaaa9999aaaa9999aaaa9999aaaa
ALGOLIASEARCH_API_KEY_SEARCH=aaaa9999aaaa9999aaaa9999aaaa9999
```

If you want to disable the default pg_search, you can set `DISABLE_PG_SEARCH=true` in your ENV.


## Contributing

See the ShinyCMS developer documentation for information on contributing to this plugin or any other part of the ShinyCMS project.

Please read the Code of Conduct as well.


## Copyright and Licensing

ShinyCMS is copyright 2009-2026 Denny de la Haye https://denny.me

This ShinyCMS plugin is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later). You should have copies of both v2 and v3 of the GPL in your ShinyCMS docs folder, or you can read them online: https://opensource.org/licenses/gpl-2.0 / https://opensource.org/licenses/gpl-3.0
