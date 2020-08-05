# ShinyCMS

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
* Likes or up/down votes on posts, comments, etc
* Built-in web stats (powered by Ahoy) and email stats (powered by Ahoy::Email)
* Charts and dashboards for viewing stats (powered by Blazer)
  * Ready for use, but currently without demo data
* Support for themes (on the main site - not, currently, for the CMS admin area)
  * One theme included
* All emails use MJML templates, producing reliably cross-platform HTML emails

### Planned features

* Generic form handlers [in progress - nearly done]
  * 'email contact page to site owner', etc
* Newsletters (HTML mailshots) [in progress]
* User profile pages [in progress]
  * With content such as recent comments, recent posts, etc
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


## System dependencies

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

[Test results]: https://travis-ci.org/github/denny/ShinyCMS-ruby/builds/695548431

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

[![CircleCI](https://img.shields.io/circleci/build/github/denny/ShinyCMS-ruby?label=CircleCI&logo=circleci&logoColor=white&style=for-the-badge)](https://circleci.com/gh/denny/ShinyCMS-ruby)
[![Travis CI](https://img.shields.io/travis/com/denny/ShinyCMS-ruby?label=Travis%20CI&logo=travis&logoColor=white&style=for-the-badge)](https://travis-ci.com/denny/ShinyCMS-ruby)
[![Codecov](https://img.shields.io/codecov/c/github/denny/ShinyCMS-ruby?label=Codecov&logo=codecov&logoColor=white&style=for-the-badge)](https://codecov.io/gh/denny/ShinyCMS-ruby)

[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability-percentage/denny/ShinyCMS-ruby?label=CodeClimate&logo=code-climate&style=for-the-badge)](https://codeclimate.com/github/denny/ShinyCMS-ruby/maintainability)
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/denny/ShinyCMS-ruby?label=CodeClimate&logo=code-climate&style=for-the-badge)](https://codeclimate.com/github/denny/ShinyCMS-ruby/maintainability)
<a href="https://codebeat.co/projects/github-com-denny-shinycms-ruby-main"><img src="https://codebeat.co/badges/97ed8fca-23b4-469e-a7fb-fd3ec7f8e4d5" alt="CodeBeat (code quality)" height="28px"></a>

<a href="https://dependabot.com"><img src="https://api.dependabot.com/badges/status?host=github&repo=denny/ShinyCMS-ruby" alt="Dependabot" height="28px"></a>
<a href="https://hakiri.io/github/denny/ShinyCMS-ruby/main"><img src="https://hakiri.io/github/denny/ShinyCMS-ruby/main.svg" alt="Security" height="28px"></a>

[![GitHub](https://img.shields.io/github/license/denny/ShinyCMS-ruby?style=for-the-badge&color=brightgreen)](https://opensource.org/licenses/gpl-2.0)
[![RubyDocs](https://img.shields.io/static/v1?label=RubyDocs&color=brightgreen&message=✓&logo=ruby&style=for-the-badge)](https://rubydoc.info/github/denny/ShinyCMS-ruby)
<a href="https://inch-ci.org/github/denny/ShinyCMS-ruby"><img src="https://inch-ci.org/github/denny/ShinyCMS-ruby.svg" alt="Inline Documentation" height="28px"></a>
