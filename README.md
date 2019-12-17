# ShinyCMS (Ruby version)

I'm re-implementing [ShinyCMS](https://shinycms.org/) in
[Ruby](https://ruby-lang.org/), as an educational exercise...

[The original version](https://github.com/denny/ShinyCMS)
is written in [Perl](https://perl.org/).

The Perl version of ShinyCMS was built to satisfy the varied requirements of a
number of clients during 10 years of working as a freelance web developer, so
it's not a small project. Here's the feature list I'm trying to duplicate:

* Content-managed pages, page templates, and form handlers
* User accounts, profiles and administration
* Blog
* News/PR section
* Newsletters (HTML mailshots)
* Online shop
* Access control system which can be used to change page content, allow downloads, etc
* Payment handling system, including recurring subscriptions (linked to access control)
* Tags on blog posts, news posts, forum posts, and shop items
* Nested comment threads on blog posts, news posts, forum posts, and shop items
* 'Likes' on blog posts, shop items, and comments
* Event listings
* Forums
* Polls
* 'Shared content' - store text and HTML fragments for re-use throughout a site

Ideally I'll be improving on each of these as I re-implement them. :)


## Ruby and Rails versions

I'm aiming to track latest stable Ruby and Rails, which means I started with
Ruby 2.6.4 and Rails 6.0.0, and I'm currently on Ruby 2.6.5 and Rails 6.0.2

I believe there are some Rails-6-isms in the code which mean it won't run on
rails 5.x without at least minor modifications; I don't intend to put any effort
into supporting earlier versions of Rails for now.

I don't know of any reason that it shouldn't run on older Ruby versions, but I
haven't tested it and I don't know how much older; if I get any feedback on what
does or doesn't work then I'll include it here in future.


## System dependencies

Currently just the contents of the Gemfile and a Postgres database, I think.


## Configuration

For a standard local development setup, it should Just Work [tm] as far as I'm
aware.


## Database

To create the database: `rails db:create`  
To load the database schema: `rails db:schema:load`  
To load seed data: `rails db:seed`

To do all three in one command: `rails db:setup`

To load the demo site data: `tools/insert-demo-site-data` (and set
SHINYCMS_THEME=halcyonic in your ENV to use the relevant templates)


## Tests

To run the linter: `rubocop`

To run the test suite: `rspec`

To install git hooks to check these automatically when you commit/push, run
`tools/install-git-hooks`

You can view test history on CircleCI and Travis CI:  
https://circleci.com/gh/denny/ShinyCMS-ruby  
https://travis-ci.org/denny/ShinyCMS-ruby

And test coverage information on CodeCov:  
https://codecov.io/gh/denny/ShinyCMS-ruby


## Current Status

[![CircleCI](https://circleci.com/gh/denny/ShinyCMS-ruby.svg?style=svg&circle-token=5d3c249b624bd720b7481eb606893737ba65a0ce)](https://circleci.com/gh/denny/ShinyCMS-ruby) (CircleCI) [![Travis CI](https://travis-ci.org/denny/ShinyCMS-ruby.svg?branch=master)](https://travis-ci.org/denny/ShinyCMS-ruby) (Travis CI) [![codecov](https://codecov.io/gh/denny/ShinyCMS-ruby/branch/master/graph/badge.svg?token=Pm6x6VcQ81)](https://codecov.io/gh/denny/ShinyCMS-ruby) (CodeCov) [![Maintainability](https://api.codeclimate.com/v1/badges/944f9f96599145fdea77/maintainability)](https://codeclimate.com/github/denny/ShinyCMS-ruby/maintainability) (CodeClimate) [![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=denny/ShinyCMS-ruby)](https://dependabot.com) (Dependabot)


## Services

None currently. Probably needs an outgoing email queue soon, to send user
registration confirmations, and I intend to use S3 for image hosting.


## Deployment

There's a Procfile for easy deployment to Heroku. You can run a basic install of
ShinyCMS on there for free, using a Free Dyno for web and a Postgres add-on at
the Hobby Dev level.


## Licensing

ShinyCMS (Ruby version) is free software; you can redistribute it and/or modify
it under the terms of the GPL (version 2 or later). There are copies of both v2
and v3 of the GPL in the docs folder, or you can read them online:  
https://opensource.org/licenses/gpl-2.0  
https://opensource.org/licenses/gpl-3.0

ShinyCMS uses code from other open source and free software projects, which
have their own licensing terms; see docs/LICENSES.md for details.
