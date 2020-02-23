# ShinyCMS (Ruby version)

I'm re-implementing [ShinyCMS](https://shinycms.org/) in
[Ruby](https://ruby-lang.org/), as an educational exercise...

The original, [Perl version of ShinyCMS](https://github.com/denny/ShinyCMS) was
built to satisfy the varied requirements of a number of clients during 10 years
of working as a freelance web developer, so it's not a small project.

As well as this project allowing me to gain more familiarity with the full Ruby
on Rails project lifecycle, I also intend to make improvements to many of the
features as I re-implement them, with the benefit of hindsight - and an extra
decade of professional experience since the original project started.


## Progress

Features that currently exist in the Ruby version (noting improvements from
the Perl version, if any):

* Pages, with page templates, page sections, and dynamically-generated menus
  * Improvements: the Perl version required all pages to be in a section, and
    you could only nest sections two levels deep. The Ruby version allows you
    to have pages at the top-level of your site, and to nest sections to any
    depth.
* Inserts (re-usable content fragments that can be pulled into any template)
  * Improvements: snappier name? ;) (Renamed from Shared Content to Inserts)
* User accounts and administration
  * Improvements: the Perl version has role-based authorisation. The Ruby
    version has more flexible ACL-based authorisation.
* reCAPTCHA bot protection for registration and comment forms
  * Improvements: supports reCAPTCHA v3 with scores. Tries an invisible
    CAPTCHA first, falling back to an interactive CAPTCHA if that fails.
* Blog
* Tags on blog posts (and ready to add to any other content type)
* Nested comment threads on blog posts (ready to add to any other content type)
  * Improvements: Perl's main ORM doesn't have native support for polymorphism,
    so I ended up writing my own version of it (although I didn't know the term
    'polymorphism' at the time). The Ruby version of the Discussions feature
    was considerably easier to implement, and is hopefully easier for other
    developers to understand, as it uses the native support for polymorphism
    in ActiveRecord.


## TODO

Features the Perl version has, which the Ruby version doesn't. Yet.

* Form handlers (contact page, etc)
* News section
* Newsletters (HTML mailshots)
* Akismet spam filtering for comments, with moderation page
* 'Likes' on blog posts, shop items, and comments
* User profile pages (with content such as recent comments, recent posts, etc)
* Access control system
  * Can be used to control access to file downloads and secure whole pages,
    but also to show/hide individual pieces of page content
* Payment handling plugins, including recurring subscriptions (linked to access control)
* Online shop
* Event listings
* Forums
* Polls


## Ruby and Rails versions

I'm aiming to keep up to date with the current/latest stable versions of Ruby
and Rails, which means I started with Ruby 2.6.4 and Rails 6.0.0, and I'm
currently on Ruby 2.6.5 and Rails 6.0.2.1 (I did update to Ruby 2.7.0 briefly,
but I got fed up with all the deprecation warnings; I've moved back to 2.6.5
until 2.7.0 support settles down a bit).

I believe there are some Rails-6-isms in the code which mean it won't run on
rails 5.x without at least minor modifications; I don't intend to put any effort
into supporting earlier versions of Rails, and any patches to add that support
will need to be convincingly clean.

I don't know of any reason that ShinyCMS shouldn't run on older Ruby versions,
but I haven't tested it yet so I don't know how much older; when I run those
tests, or if if I get any feedback on what does or doesn't work, then I'll
update this doc.


## System dependencies

* A webserver
  * I use `foreman run rails s` for dev, and Heroku for staging and production
* A database
  * For now this assumes Postgres, although I intend to work toward being
    database agnostic eventually (the Perl version works with MySQL, Postgres,
    and quite probably anything else that the DBIx::Class ORM supports).

To enable certain features, you will need keys from or accounts on various
external services...


## Services

External services are mostly optional. If you add config settings for them
(via ENV vars on the command line, or via a .env file (see .env.example),
or via your Config Vars on Heroku) then they will be enabled, otherwise
either those features will be disabled or a fallback will take their place.

#### AWS S3 - file storage

User uploaded files can be stored on AWS S3 instead of locally. To enable this
feature you will need to have an an AWS account, create an S3 bucket, and add
the relevant keys to the ENV/config.

#### reCAPTCHA - bot protection

User registration and posting comments can be protected from bots using Google's
reCAPTCHA service. To enable this feature you will need to obtain keys and add
them to your ENV/config. You will get the best results with a pair of V3 keys
and a pair of V2 keys (this allows you to set a minimum score for each protected
feature in your Site Settings area). At first reCAPTCHA tries an 'invisible'
(non-interactive) check (V3 with score if configured, V2 otherwise), falling
back to a V2 checkbox if that fails.

#### Have I Been Pwned - password leak checking

The user registration and login features use Devise::PwnedPassword to check
user's passwords against https://haveibeenpwned.com/Passwords and warn the
user if they find a match, but this doesn't require any setup on your part.


## Database

To create the database: `rails db:create`  
To load the database schema: `rails db:schema:load`  
To load seed data: `rails db:seed`

To do all three in one command: `rails db:setup`

To load the demo site data: `tools/insert-demo-site-data`


## Tests

To run the linter: `rubocop`

To run the test suite: `rspec`

To install git hooks to check these automatically when you commit/push, install
[Overcommit](https://github.com/sds/overcommit) (a config file is included).

You can view test results on
[CircleCI](https://circleci.com/gh/denny/ShinyCMS-ruby) and
[Travis CI](https://travis-ci.org/denny/ShinyCMS-ruby), and test coverage on
[CodeCov](https://codecov.io/gh/denny/ShinyCMS-ruby).


## Deployment

There's a Procfile for easy deployment to Heroku. You can run a test/demo
install of ShinyCMS on there for free, using a Free Dyno for web and a
Postgres add-on at the Hobby Dev level.


## Current Status

[![CircleCI](https://circleci.com/gh/denny/ShinyCMS-ruby.svg?style=svg&circle-token=5d3c249b624bd720b7481eb606893737ba65a0ce)](https://circleci.com/gh/denny/ShinyCMS-ruby)  [![Travis CI](https://travis-ci.org/denny/ShinyCMS-ruby.svg?branch=master)](https://travis-ci.org/denny/ShinyCMS-ruby)  [![codecov](https://codecov.io/gh/denny/ShinyCMS-ruby/branch/master/graph/badge.svg?token=Pm6x6VcQ81)](https://codecov.io/gh/denny/ShinyCMS-ruby)  

[![Maintainability](https://api.codeclimate.com/v1/badges/944f9f96599145fdea77/maintainability)](https://codeclimate.com/github/denny/ShinyCMS-ruby/maintainability)  [![codebeat badge](https://codebeat.co/badges/cbd8fc61-241a-4701-9716-d4264cb6d9d9)](https://codebeat.co/projects/github-com-denny-shinycms-ruby-master)  [![Inline docs](http://inch-ci.org/github/denny/ShinyCMS-ruby.svg?branch=master)](http://inch-ci.org/github/denny/ShinyCMS-ruby)

[![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=denny/ShinyCMS-ruby)](https://dependabot.com)  [![Security](https://hakiri.io/github/denny/ShinyCMS-ruby/master.svg)](https://hakiri.io/github/denny/ShinyCMS-ruby/master)


## Licensing

ShinyCMS (Ruby version) is free software; you can redistribute it and/or modify
it under the terms of the GPL (version 2 or later). There are copies of both v2
and v3 of the GPL in the docs folder, or you can read them online:  
https://opensource.org/licenses/gpl-2.0  
https://opensource.org/licenses/gpl-3.0

ShinyCMS uses code from other open source and free software projects, which have
their own licensing terms; see docs/licenses.md for details.
