# ShinyCMS (Ruby version)

[ShinyCMS](https://shinycms.org/) is an open-source content management system
intended for use by web designers and web developers who want to keep a clear
distinction between the markup they create and the content their clients can
edit.

This version is built in Ruby on Rails, and has support for cloud hosting
(Heroku, AWS, etc).

This rewrite started out as as an educational exercise, giving me an opportunity
to build a Ruby on Rails application from scratch and largely by myself. It's
also been nice to have time for proper testing (100% coverage!), regular
refactoring, and all the other things I don't get to do enough of at work :)


## Features

### Current features

* User accounts and administration
  * ACL-based authorisation system for admins (powered by Pundit)
  * Uses reCAPTCHA to block registration by bots
* Web interface for site settings
  * Change most site settings from within the CMS admin area
  * Easily enable or disable CMS features (e.g. new user registrations)
  * Decide which settings to allow site users to override (e.g. theme)
* Pages and Page Sections
  * Can be added and removed by CMS admin users
  * Have defined content areas which can be edited by admins
  * Page layout controlled by Page Templates (can be provided by a theme,
    or custom-built by web designer/developer)
  * Dynamically generated menus
* Inserts (re-usable content fragments that can be pulled into any template)
* News section
* Blog
* Comments (currently enabled on blog posts and news posts)
  * Fully nested, so you can easily see who is replying to who at any level
  * Email notifications
  * Uses reCAPTCHA to block comments from bots
  * Uses Akismet to flag potential spam comments for moderation
    * Spam comment moderation sends 'spam'/'not spam' training data to Akismet
* Tags
  * Currently on blog posts and news posts, ready to add to new content types
* Built-in web stats (powered by Ahoy) and email stats (powered by Ahoy::Email)
* Support for themes

### Planned features

* Newsletters (HTML mailshots) [in progress]
* Charts and dashboards for viewing stats [in progress]
* Form handlers (contact page, etc)
* 'Likes' on posts, comments, etc
* User profile pages (with content such as recent comments, recent posts, etc)
* Access control groups
  * Can be used to control access to file downloads and secure whole pages,
    but also to show/hide individual pieces of page content
* Payment handling plugins
  * Options include recurring subscriptions to access control groups (AKA paid membership)
* Online shop
* Event listings
* Forums
* Polls

(See the developer documentation for more detailed information on features
[in progress](docs/Developer/Progress.md) and [to-do](docs/Developer/TODO.md))


## Installation and configuration

If you want to set up a website using ShinyCMS, please read the
[Getting Started](docs/Getting-Started.md) guide.

### Demo site

Theme templates and sample data for a demo site are provided, so you can try
all of the CMS features without doing any set-up work.

### System dependencies

* A webserver - I use `rails s` locally, and deploy to Heroku
* A database - for now this assumes Postgres
* An email server or service - anything that ActionMailer supports

### Services

External services are mostly optional. If you add config settings for them
(in ENV, .env*, or Heroku config vars) then they will be enabled, otherwise
either those features will be disabled or a fallback will take their place.

### Ruby and Rails versions

ShinyCMS requires Rails 6 (which in turn requires Ruby 2.5 or later), and
generally uses the most recent stable release of both Ruby and Rails
(currently Ruby 2.7.1 and Rails 6.0.3).

It has been tested on every release of Rails 6 so far, and with most versions
of Ruby from 2.5.8 onwards ([view recent test results][test results] for ruby
2.5.8, 2.6.6, and 2.7.1).

[Test results]: https://travis-ci.org/github/denny/ShinyCMS-ruby/builds/677015096

There are currently no plans to add support for Rails 5 or older Ruby versions.


## Licensing

ShinyCMS (Ruby version) is free software; you can redistribute it and/or modify
it under the terms of the GPL (version 2 or later). There are copies of both v2
and v3 of the GPL in [docs/Licensing](docs/Licensing/index.md), or you can read
them online:  
https://opensource.org/licenses/gpl-2.0  
https://opensource.org/licenses/gpl-3.0

ShinyCMS includes code from other open source and free software projects, which
have their own licensing terms; please read the
[licensing docs](docs/Licensing/index.md) for more details.


## Code of Conduct

This project has a [Code of Conduct](docs/code-of-conduct.md), which is intended
to make using ShinyCMS, or contributing to it, a harassment-free experience for
everybody involved - regardless of who they are and what they do or don't know.

Please read and follow the code of conduct - thank you.


## Current Status

[![CircleCI: Tests](https://circleci.com/gh/denny/ShinyCMS-ruby.svg?style=svg&circle-token=5d3c249b624bd720b7481eb606893737ba65a0ce)](https://circleci.com/gh/denny/ShinyCMS-ruby)  [![Travis CI: Tests](https://travis-ci.org/denny/ShinyCMS-ruby.svg?branch=master)](https://travis-ci.org/denny/ShinyCMS-ruby)  [![codecov: Test Coverage](https://codecov.io/gh/denny/ShinyCMS-ruby/branch/master/graph/badge.svg?token=Pm6x6VcQ81)](https://codecov.io/gh/denny/ShinyCMS-ruby)

[![CodeClimate: Maintainability](https://api.codeclimate.com/v1/badges/944f9f96599145fdea77/maintainability)](https://codeclimate.com/github/denny/ShinyCMS-ruby/maintainability)  [![CodeBeat: Code Quality](https://codebeat.co/badges/cbd8fc61-241a-4701-9716-d4264cb6d9d9)](https://codebeat.co/projects/github-com-denny-shinycms-ruby-master)  [![Inch: Inline docs](http://inch-ci.org/github/denny/ShinyCMS-ruby.svg?branch=master)](http://inch-ci.org/github/denny/ShinyCMS-ruby)

[![Dependabot: Gem versions](https://api.dependabot.com/badges/status?host=github&repo=denny/ShinyCMS-ruby)](https://dependabot.com)  [![Hakiri: Security](https://hakiri.io/github/denny/ShinyCMS-ruby/master.svg)](https://hakiri.io/github/denny/ShinyCMS-ruby/master)
