# ShinySEO: Search Engine Optimisation plugin for ShinyCMS

ShinySEO is a plugin for [ShinyCMS](https://shinycms.org) which adds SEO-related features such as sitemaps and meta-tags to your ShinyCMS website.


## Installation

Add 'ShinySEO' to the SHINYCMS_PLUGINS ENV var, then run `bundle install` for your main ShinyCMS app.

Currently, all plugins are enabled by default, so you don't actually need to set the ENV var unless you want to load a subset of plugins or change the load order (which mostly just changes the order of the menus in your admin area).

<!--
  TODO: Uncomment this when the meta-tag features are written and have migrations etc
  (Currently this plugin only generates sitemaps, which doesn't write to the database)

To add the ShinySEO tables and supporting data to your
ShinyCMS database:
```bash
rails shiny_seo:install:migrations
rails db:migrate
rails shiny_seo:db:seed
```
-->

### Sitemap Generator

ShinySEO uses the [sitemap_generator](https://github.com/kjvarga/sitemap_generator) gem to generate XML sitemap files for consumption by search engines such as Google and Bing, and to notify those services when your sitemap is updated.

The easiest way to try it out is via the rake tasks:
```bash
rails sitemap:create      # Generate sitemaps but don't ping search engines
rails sitemap:refresh     # Generate sitemaps and ping search engines
```

By default, the new sitemap file or files are written to public/sitemap*.xml.gz

If you have AWS_S3_FEEDS_* details in your ENV then the files will be written to that AWS S3 bucket instead. This is useful if your site is hosted on a cloud service without permanent storage, e.g. Heroku.


## Contributing

See the ShinyCMS developer documentation for information on contributing to this plugin or any other part of the ShinyCMS project.

Please read the Code of Conduct as well.


## Copyright and Licensing

ShinyCMS is copyright 2009-2026 Denny de la Haye https://denny.me

This ShinyCMS plugin is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later). You should have copies of both v2 and v3 of the GPL in your ShinyCMS docs folder, or you can read them online: https://opensource.org/licenses/gpl-2.0 / https://opensource.org/licenses/gpl-3.0
