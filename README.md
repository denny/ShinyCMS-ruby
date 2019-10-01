ShinyCMS (Ruby version)
=======================

I'm re-implementing [ShinyCMS](https://shinycms.org/) in
[Ruby](https://ruby-lang.org/), as an educational exercise...

[The original version](https://github.com/denny/ShinyCMS)
is written in [Perl](https://perl.org/).

I built most of the Perl version while I was freelancing between 2009 and 2016,
and I've added a few minor features and a lot of test coverage since then; it's
not a small project.

The Perl version of ShinyCMS has the following features:

* Content-managed pages, page templates, and forms
* User accounts, profiles and administration
* Blog
* News/PR section
* Newsletters (HTML mailshots)
* Online shop
* Membership system which can control access to files, pages, or even paragraphs
* Payment handling system which can handle recurring subscriptions
* Tags on blog posts, news posts, forum posts, and shop items
* Nested comment threads on blog posts, news posts, forum posts, and shop items
* 'Likes' on blog posts, shop items, and comments
* Event listings
* Forums
* Polls
* 'Shared content' - store text and HTML fragments for re-use throughout a site

I hope to re-implement all of these eventually... hopefully improving on some
of them in the process.


Ruby version
------------

I'm setting out with current latest stable, which is Ruby 2.6.4 and Rails 6.0.0


System dependencies
-------------------

TODO


Configuration
-------------

TODO


Database
--------

To create the database: `rake db:create`  
To load the database schema: `rake db:schema:load`  
To load seed data: `rake db:seed`

To do all three in one command: `rake db:setup`


Tests
-----

To run the test suite: `rspec`


Services
--------

TODO


Deployment
----------

TODO


Current Status
--------------

[![CircleCI](https://circleci.com/gh/denny/ShinyCMS-ruby.svg?style=svg&circle-token=5d3c249b624bd720b7481eb606893737ba65a0ce)](https://circleci.com/gh/denny/ShinyCMS-ruby) (CircleCI)  [![codecov](https://codecov.io/gh/denny/ShinyCMS-ruby/branch/master/graph/badge.svg?token=Pm6x6VcQ81)](https://codecov.io/gh/denny/ShinyCMS-ruby) (CodeCov) [![Maintainability](https://api.codeclimate.com/v1/badges/944f9f96599145fdea77/maintainability)](https://codeclimate.com/github/denny/ShinyCMS-ruby/maintainability) (CodeClimate)
