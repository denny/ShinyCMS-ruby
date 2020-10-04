# ShinyCMS

[ShinyCMS](https://shinycms.org/) is an open-source content management system built in Ruby on Rails, with support for cloud hosting (Heroku, AWS, etc).

It is intended primarily for use by web designers and web developers to build content-managed websites for their clients. Page layouts are defined by templates (built by a front-end developer or provided by a theme) which designate specific pieces of content as editable (text, images, etc). These can then be updated via an easy-to-use admin interface - protecting page layouts from accidental edits, and making editing content a simple and safe process for non-technical site admins.

ShinyCMS has a plugin architecture; you can add custom functionality by [writing your own plugins](docs/Developer/Plugins.md) (`rails g shiny:plugin plugins/ShinyThing` to get started)


## Features

* Provided by plugins:
  * Pages and Page Sections
    * Site admins can add as many pages and (nested) sections as they like
    * Pages have defined content areas which can be edited by admins
    * Page layout is controlled by Page Templates (can be provided by a theme or custom-built)
    * Dynamically generated menus
  * Inserts (re-usable content fragments that can be pulled into any template)
  * News section
  * Blog
  * Mailing lists
  * Newsletters
  * Basic form handlers (e.g. contact form submitted -> email form data to site owner)
  * Site search feature (supports multiple search back-ends; default is pg_search)
  * Load only the plugins you want/need - smaller footprint, smaller attack surface
* Provided by the main app:
  * Comments (currently enabled on blog posts and news posts)
    * Fully nested, so you can easily see who is replying to who at any level
    * Email notifications of replies to your comments and posts
    * Uses reCAPTCHA to block comments from bots
    * Uses Akismet to flag potential spam comments for moderation
      * Spam comment moderation sends 'spam'/'not spam' training data to Akismet
  * Tags (currently enabled on blog posts and news posts, ready to add to any content type)
  * Likes or up/down votes on posts, comments, etc
  * User accounts and administration
    * ACL-based authorisation system for admins (powered by Pundit)
    * Uses reCAPTCHA to block registration by bots
* Support for [themes](docs/Themes.md) on the hosted site
  * Light-lift theme system - you only need to override the default templates that you want to change
  * Two themes currently included:
    * Halcyonic (one, two, and three column layouts; suitable for content-rich sites)
    * Coming Soon (single page with mailing list sign-up form and slideshow background)
* Web interface for site settings
  * Change most site settings from within the CMS admin area
  * Easily enable or disable CMS features (e.g. new user registrations)
  * Decide which settings to allow site users to override (e.g. theme)
* All emails use MJML templates, producing reliably cross-platform HTML emails
* Built-in web stats (powered by Ahoy) and email stats (powered by Ahoy::Email)
* Charts and dashboards for viewing stats (powered by Blazer)

### Planned features

* Default dashboard(s) and queries for Blazer
* More themes
* User profile pages
  * With content such as recent comments, recent posts, etc
* Algolia support for search plugin [in progress]
* Support for multiple blogs on a single site [in progress]
* Access control groups
  * Can be used to control access to file downloads and secure whole pages, but also to show/hide individual pieces of page content (images/paragraphs/words/etc)
* Payment handling plugins
  * Options include recurring subscriptions to access control groups (AKA paid membership)
* Online shop
* ... and more :)

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

ShinyCMS requires Rails 6 (which in turn requires Ruby 2.5 or later), and generally uses the most recent stable release of both Ruby and Rails (currently Ruby 2.7.1 and Rails 6.0.3).

It has been tested on every release of Rails 6 so far, and with most versions of Ruby from 2.5.8 onwards ([view recent test results][test results] for ruby 2.5.8, 2.6.6, and 2.7.1).

[Test results]: https://travis-ci.com/github/denny/ShinyCMS-ruby/builds/184397336

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
