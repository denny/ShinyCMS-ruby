# ShinyCMS

[ShinyCMS](https://shinycms.org/) is an open-source content management system built in Ruby on Rails, with support for [themes](docs/Themes.md), [plugins](docs/Developer/Plugins.md), and cloud hosting.

It is designed for professional web developers to use as a platform when building content-managed websites for their clients. It provides a number of features 'out of the box', with an easy-to-use admin interface for your clients to use when updating their site. You can also write your own plugins to add custom functionality.

To build a basic site on top of ShinyCMS, you just need to know HTML and ERB well enough to make any custom page templates that your site needs, or to modify those provided (at least until more ready-made themes are available; themes are easy to make, and theme contributions are very welcome).


## Features

* [Plugin architecture](docs/Developer/Plugins.md)
  * Load only the features you want; reduce in-memory size and attackable surface area
  * Add custom functionality easily by writing your own plugins
  * All features marked with ± below are provided by a plugin
* [Themes](docs/Themes.md) (on the hosted site)
  * Light-lift theme system - you can override just a few of the default partials if you want
  * Two themes included; Halcyonic, for content-rich sites, and Coming Soon for pre-launch sites
* [Pages](docs/Features/Plugins/ShinyPages.md) ±
  * Content-controlled 'brochure pages', with layout controlled by Page Templates
  * Can be organised into Page Sections (nested to any depth), with dynamically generated menus
* [Inserts](docs/Features/Plugins/ShinyInserts.md) ±
  * Re-usable content fragments that can be pulled into any template on any page
* [News section](docs/Features/Plugins/ShinyNews.md) ±
* [Blog](docs/Features/Plugins/ShinyBlog.md) ±
* [Comments](docs/Features/MainApp/Comments.md)
  * Ready to add to any content; enabled by default on blog posts and optionally on news posts
  * Fully nested comment threads, so you can easily see who is replying to who at any level
  * Email notifications of replies to comments and posts
  * Uses [reCAPTCHA](https://developers.google.com/recaptcha/) to block bots, and [Akismet](https://akismet.com/) to flag potential spam for moderation
    * Spam moderation feature sends training data back to Akismet, to improve its accuracy in future
* [Mailing lists](docs/Features/Plugins/ShinyLists.md) ±
  * Double opt-in, user subscription management, 'do not contact' feature
* [Newsletters](docs/Features/Plugins/ShinyNewsletters.md) ±
  * HTML mailshots, produced from MJML templates for cross-platform compatibility
* [Basic form handlers](docs/Features/Plugins/ShinyForms.md)
  * e.g. 'email form data to site owner' - useful for contact and enquiry forms
* [Site search](docs/Features/Plugins/ShinySearch.md) ±
  * Ready to support multiple search backends (default is pg_search multisearch)
* [Tags](docs/Features/MainApp/Tags.md)
* [Upvotes](docs/Features/MainApp/Upvotes.md) (AKA 'likes') on posts and comments
* [User profile pages](docs/Features/Plugins/ShinyProfiles.md) ±
  * Links to user-provided content such as recent comments, recent blog posts, etc
* [User accounts](docs/Features/MainApp/UserAccounts.md) and administration
  * ACL-based authorisation system for admins (powered by [Pundit](https://github.com/varvet/pundit))
  * Uses [reCAPTCHA](https://developers.google.com/recaptcha/) to block registration by bots
* Web interface for [site settings](docs/Features/MainApp/SiteSettings.md) and [feature flags](docs/Features/MainApp/FeatureFlags.md)
* All emails are generated from MJML templates, producing reliably cross-platform HTML emails
* Built-in tracking of [web stats](docs/Features/MainApp/WebStats.md) and [email stats](docs/Features/MainApp/EmailStats.md) (powered by [Ahoy](https://github.com/ankane/ahoy) and [Ahoy::Email](https://github.com/ankane/ahoy_email))
* Build your own [charts and dashboards](docs/Features/MainApp/Charts.md) for viewing and analyzing stats (powered by [Blazer](https://github.com/ankane/blazer))

### Planned features

* Content Access Groups
  * Control access to large items - file downloads, whole pages on the site
  * Or smaller items within a page - specific images, page sections, even individual words
* Payment handling plugins
  * Including recurring subscriptions to content access groups - AKA paid membership
* Online shop
* Support for multiple blogs on a single site (in progress)
* [Algolia](https://www.algolia.com/) support for search plugin (in progress)
* Default dashboard and charts for Blazer
* More themes!

(See the [developer documentation](docs/Developers/index.md) for more detailed information on features [in progress](docs/Developers/in-progress.md) and [to-do](docs/Developers/TODO.md))


## Installation and configuration

If you want to set up a website using ShinyCMS, please read the [Getting Started](docs/Getting-Started.md) guide.

### Demo site

Theme templates and sample data for a demo site are provided, so you can try all of the CMS features without doing any set-up work.


## System dependencies

* A webserver - I use `rails s` locally, and deploy to Heroku
* A database - for now this assumes Postgres
* An email server or service - anything that ActionMailer supports

### Ruby and Rails versions

ShinyCMS requires Rails 6 (which in turn requires Ruby 2.5 or later), and generally uses the most recent stable release of both Ruby and Rails (currently Ruby 2.7.2 and Rails 6.0.3).

It has been tested on every release of Rails 6 so far, and with most versions of Ruby from 2.5.8 onwards ([view recent test results][test results] for ruby 2.5.8, 2.6.6, and 2.7.1).

[Test results]: https://travis-ci.com/github/denny/ShinyCMS-ruby/builds/188454649

There are currently no plans to add support for Rails 5 or older Ruby versions.

### Services

External services are mostly optional. If you add config settings for them (in ENV, .env*, or Heroku config vars) then they will be enabled, otherwise either those features will be disabled or (where possible) a fallback will take their place.


## Contributing

If you're interested in contributing to ShinyCMS, please start by reading the [developer documentation](docs/Developers/index.md).


## Code of Conduct

This project has a [Code of Conduct](docs/code-of-conduct.md), which is intended to make using ShinyCMS, or contributing to it, a harassment-free experience for everybody involved - regardless of who they are and what they do or don't know.

Please read and follow the code of conduct - thank you.


## Copyright and Licensing

ShinyCMS is copyright 2009-2020 Denny de la Haye - https://denny.me

ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later). There are copies of both [v2](docs/Licensing/gnu-gpl-2.0.md) and [v3](docs/Licensing/gnu-gpl-3.0.md) of the GPL in [docs/Licensing](docs/Licensing/index.md), or you can read them online: https://opensource.org/licenses/gpl-2.0 / https://opensource.org/licenses/gpl-3.0

ShinyCMS includes code from other open source and free software projects, which have their own licensing terms; please read the [licensing docs](docs/Licensing/index.md) for more details.


## Current Status

[![CircleCI](https://img.shields.io/circleci/build/github/denny/ShinyCMS-ruby?label=CircleCI&logo=circleci&logoColor=white&style=for-the-badge)](https://circleci.com/gh/denny/ShinyCMS-ruby)
[![Travis CI](https://img.shields.io/travis/com/denny/ShinyCMS-ruby?label=Travis%20CI&logo=travis&logoColor=white&style=for-the-badge)](https://travis-ci.com/denny/ShinyCMS-ruby)
[![Codecov](https://img.shields.io/codecov/c/github/denny/ShinyCMS-ruby?label=Codecov&logo=codecov&logoColor=white&style=for-the-badge)](https://codecov.io/gh/denny/ShinyCMS-ruby)

[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/denny/ShinyCMS-ruby?label=CodeClimate&logo=code-climate&style=for-the-badge)](https://codeclimate.com/github/denny/ShinyCMS-ruby/maintainability)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/denny/ShinyCMS-ruby?label=CodeFactor&logo=codefactor&logoColor=white&style=for-the-badge)](https://www.codefactor.io/repository/github/denny/shinycms-ruby)
<a href="https://codebeat.co/projects/github-com-denny-shinycms-ruby-main"><img src="https://codebeat.co/badges/97ed8fca-23b4-469e-a7fb-fd3ec7f8e4d5" alt="CodeBeat (code quality)" height="28px"></a>

[![Dependabot](https://img.shields.io/static/v1?label=Dependabot&color=brightgreen&message=enabled&logo=dependabot&style=for-the-badge)](https://rubydoc.info/github/denny/ShinyCMS-ruby)
<a href="https://hakiri.io/github/denny/ShinyCMS-ruby/main"><img src="https://hakiri.io/github/denny/ShinyCMS-ruby/main.svg" alt="Security" height="28px"></a>

![GitHub code size](https://img.shields.io/github/languages/code-size/denny/ShinyCMS-ruby?logo=github&style=for-the-badge)
![GitHub repo size](https://img.shields.io/github/repo-size/denny/ShinyCMS-ruby?logo=github&style=for-the-badge)
[![GitHub](https://img.shields.io/github/license/denny/ShinyCMS-ruby?color=blue&logo=gnu&style=for-the-badge)](https://opensource.org/licenses/gpl-2.0)
