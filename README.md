# ShinyCMS

[ShinyCMS](https://shinycms.org/) is an open-source content management system built in Ruby on Rails, with support for [themes](docs/Themes.md), [plugins](docs/Developer/Plugins.md), and [cloud hosting](docs/Cloud-Hosting.md).

ShinyCMS is primarily intended for use by professional web developers, as a platform to build content-managed websites on top of. It provides a number of features 'out of the box', which all integrate into its easy-to-use admin area. Access to admin features is managed by a highly granular ACL system.

Web developers can also add custom functionality by writing their own plugins. A number of helpers and concerns are provided to help you build new features quickly, and with a consistent look-and-feel to the rest of the system.

The current version of ShinyCMS runs on Ruby 3.4 and Rails 8.1

## Features

* [Plugin architecture](docs/Developer/Plugins.md) 𐍈
  * Load the core plugin, plus only the feature plugins that you want to use
    * Reduces in-memory size and attackable surface area
  * Add custom functionality easily by writing your own plugins
  * Items on this list marked with 𐍈 are provided by the core plugin
  * Items on this list marked with ± are provided by one of the feature plugins
* [Themes](docs/Themes.md) (on the hosted site) 𐍈
  * Light-lift theme system - you can override just a few of the default partials if you want
  * Two themes included; Halcyonic, for content-rich sites, and Coming Soon for pre-launch sites
* [Pages](docs/Features/Plugins/ShinyPages.md) ±
  * Content-controlled 'brochure pages', with layout controlled by Page Templates
  * Can be organised into Page Sections (nested to any depth), with dynamically generated menus
* [Inserts](docs/Features/Plugins/ShinyInserts.md) ±
  * Re-usable content fragments that can be pulled into any template on any page
* [News section](docs/Features/Plugins/ShinyNews.md) ±
* [Blog](docs/Features/Plugins/ShinyBlog.md) ±
* [Comments](docs/Features/MainApp/Comments.md) 𐍈
  * Ready to add to any content; enabled by default on blog posts and optionally on news posts
  * Fully nested comment threads, so you can easily see who is replying to who at any level
  * Email notifications of replies to comments and posts
  * Uses [reCAPTCHA](https://developers.google.com/recaptcha/) to block bots, and [Akismet](https://akismet.com/) to flag potential spam for moderation
    * Spam moderation feature sends training data back to Akismet, to improve its accuracy in future
* [Mailing lists](docs/Features/Plugins/ShinyLists.md) ±
  * Double opt-in, user subscription management, 'do not contact' feature
* [Newsletters](docs/Features/Plugins/ShinyNewsletters.md) ±
  * HTML mailshots, generated from MJML templates for cross-platform compatibility
* [Basic form handlers](docs/Features/Plugins/ShinyForms.md) ±
  * e.g. 'email form data to site owner' - useful for contact and enquiry forms
  * Protected by [reCAPTCHA](https://developers.google.com/recaptcha/) and [Akismet](https://akismet.com/)
* [Access control](docs/Features/Plugins/ShinyAccess.md) ±
  * Create access groups, and add/remove members from them,
  * Use the `current_user_can_access?( :group_name )` helper to show/hide content
* [Site search](docs/Features/Plugins/ShinySearch.md) ±
  * Ready to support multiple search backends (default is pg_search multisearch)
* [Tags](docs/Features/MainApp/Tags.md) 𐍈
* [Upvotes](docs/Features/MainApp/Upvotes.md) (AKA 'likes') on posts and comments
  * Supports downvotes too, if you want a full rating/ranking system
* [User profile pages](docs/Features/Plugins/ShinyProfiles.md) ±
  * With links to user-generated content such as recent comments, recent blog posts, etc
* [User accounts](docs/Features/MainApp/UserAccounts.md) 𐍈
  * User administration in website admin area
  * Authentication powered by [Devise](https://github.com/heartcombo/devise)
    * Uses [reCAPTCHA](https://developers.google.com/recaptcha/) to block registration by bots
  * ACL-based authorisation system for admin area, powered by [Pundit](https://github.com/varvet/pundit)
* [Site settings](docs/Features/MainApp/SiteSettings.md) and [feature flags](docs/Features/MainApp/FeatureFlags.md) 𐍈
  * Website admin area for both, plus a rake task for command-line access to feature flags
* Sitemap generation and search-engine notification, powered by [SitemapGenerator](https://github.com/kjvarga/sitemap_generator#readme) ±
* Emails can be generated from [MJML](docs/Features/mjml.md) or HTML templates 𐍈
  * Using MJML allows you to produce more reliably cross-platform HTML emails
  * Default MJML templates included for most features that send email
* Built-in tracking of [web stats](docs/Features/MainApp/WebStats.md) and [email stats](docs/Features/MainApp/EmailStats.md)
  * Powered by [Ahoy](https://github.com/ankane/ahoy) and [Ahoy::Email](https://github.com/ankane/ahoy_email)
* Build your own [charts and dashboards](docs/Features/MainApp/Charts.md) for viewing and analyzing stats
  * Powered by [Blazer](https://github.com/ankane/blazer)
  * Default config includes a dozen useful charts and queries to get you started

### Planned features

* Payment handling plugins
  * Including recurring subscriptions to Access Groups - AKA paid membership
* Online shop
* Support for multiple blogs on a single site (in progress)
* [Algolia](https://www.algolia.com/) support for search plugin (in progress)
* More themes!


## Documentation

* Markdown: [/docs](docs/index.md)
* Website: [docs.shinycms.org](https://docs.shinycms.org/) ([generated](https://shinycms.org/blog/2020/10/docs) from /docs)


## Installation and configuration

Please start by reading the [installation guide](docs/INSTALL.md) ([tl,dr](docs/tldr.md)).

### Demo site

Theme templates and sample data for a [demo site](docs/demo-site.md) are provided, so you can try all of the CMS features without doing any data-entry work first. You can run the demo site locally or on a free Heroku plan.

### System dependencies

You will need a webserver, a Postgres-compatible database server, and a Sidekiq-compatible caching service (e.g. Redis).

You will need a mail server if you intend to enable any of the features that send emails; user registrations, reply notifications, etc. Anything supported by ActionMailer should work.

All other supported [external services](docs/Services.md) are optional. If you add config details for them (in ENV / .env* files / Heroku config) then they will be used, otherwise the related CMS features will be unavailable or will have reduced functionality.

### Ruby and Rails versions

ShinyCMS requires Ruby 3.4 and Rails 8.1 or later. The project generally uses the most recent stable release of both Ruby and Rails (currently Ruby 3.4.5 and Rails 8.1.1).


## Contributing

Everyone is encouraged to help improve this project! Here are a few ways you can help:
* Report issues
* Improve the documentation
* Fix bugs and submit pull requests
* Suggest new features
* Add new features :)

See [contributing to ShinyCMS](docs/Contributing.md) for more information.


## Code of Conduct

This project has a [Code of Conduct](docs/code-of-conduct.md), which is intended to make using ShinyCMS, or contributing to it, a harassment-free experience for everybody involved - regardless of who they are and what they do or don't know.

Please read and follow the code of conduct - thank you.


## Copyright and Licensing

ShinyCMS is copyright 2009-2026 Denny de la Haye - https://denny.me

ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later). There are copies of both [v2](docs/Licensing/gnu-gpl-2.0.md) and [v3](docs/Licensing/gnu-gpl-3.0.md) of the GPL in [docs/Licensing](docs/Licensing/index.md), or you can read them online: https://opensource.org/licenses/gpl-2.0 / https://opensource.org/licenses/gpl-3.0

ShinyCMS includes code from other open source and free software projects, which have their own licensing terms; please read the [licensing docs](docs/Licensing/index.md) for more details.


## Current Status

[![CircleCI](https://img.shields.io/circleci/build/github/denny/ShinyCMS-ruby?label=CircleCI&logo=circleci&logoColor=white&style=for-the-badge)](https://circleci.com/gh/denny/ShinyCMS-ruby)
[![Dependabot](https://img.shields.io/static/v1?label=Dependabot&color=brightgreen&message=enabled&logo=dependabot&style=for-the-badge)](https://rubydoc.info/github/denny/ShinyCMS-ruby)
[![Codecov](https://img.shields.io/codecov/c/github/denny/ShinyCMS-ruby?label=Codecov&logo=codecov&logoColor=white&style=for-the-badge)](https://codecov.io/gh/denny/ShinyCMS-ruby)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/denny/ShinyCMS-ruby?label=CodeFactor&logo=codefactor&logoColor=white&style=for-the-badge)](https://www.codefactor.io/repository/github/denny/shinycms-ruby)

![GitHub code size](https://img.shields.io/github/languages/code-size/denny/ShinyCMS-ruby?logo=github&style=for-the-badge)
![GitHub repo size](https://img.shields.io/github/repo-size/denny/ShinyCMS-ruby?logo=github&style=for-the-badge)
[![GitHub](https://img.shields.io/github/license/denny/ShinyCMS-ruby?color=blue&logo=gnu&style=for-the-badge)](https://opensource.org/licenses/gpl-2.0)
