# ShinyCMS: TODO

## Fixes and refactoring of code already written - to do next/soon

* Add tests for form actions being what they're supposed to be on new/edit pages, and for
  delete links being correct on list pages

* Highlight section name in admin area menu when on a page which isn't in the menu
  (e.g. 'Edit page', clicking around in Blazer, etc)

* Jump admin menu to current section with an anchor

* Add exact_text option to capybara matcher calls in request specs
  * expect(bar).to have_[field/whatever], text: 'foo', exact_text: true
  * NB: Try one first; might fail on whitespace differences :eyeroll:

* Check for and add missing indexes - https://pawelurbanek.com/rails-postgres-join-indexes

* Catch Pundit::NotAuthorizedError and output `head :unauthorized` (currently 500s I think?)

### Non-trivial

* Split comment_author details off of comments, as a polymorphic (similar to email_recipients)

* ShowHide could be abstracted more AND be more useful, as a polymorphic acts_as_showable
  sort of thing - giving us show_on( :site ), show_in( :menus ), show_on( :sitemap ), etc


## Features the Perl version has, which the Ruby version doesn't. Yet. :)

### Small-ish

* Some sort of file-picker (for image elements, CKEditor, etc)
  * https://ckeditor.com/docs/ckeditor5/latest/features/image-upload/ckfinder.html
* Site map
* Affiliate cookie

### Medium-ish

* Create a sortable concern to replace page[_section].sort_order
  * Or, just use https://github.com/itmammoth/rails_sortable ?
  * make elements sortable (go via the concern, so they all get it)
    * Stretch goal, draggable UI in admin area - https://github.com/DuroSoft/rails_bootstrap_sortable ?
* Access control groups
  * Can be used to control access to file downloads and secure whole pages,
    but also to show/hide individual pieces of page content
* Polls

### Large-ish

* Online shop
* Payment handling plugins
  * Options include recurring subscriptions to access control groups (AKA paid membership)
* Forums
* Autoresponders
	* Check out Heya - may or may not be useful to use / build on top of
	* https://github.com/honeybadger-io/heya
	* Oh, except the licence doesn't look great. Investigate that first.
* Event listings
* Surveys / questionnaires


## New features that I'd like to add / features that I'd like to totally rebuild

### Small-ish

* 'Deploy to Heroku' button
  * https://devcenter.heroku.com/articles/heroku-button

* 2FA
  * https://github.com/tinfoil/devise-two-factor

* Configurable (per-site and per-user) menu order in admin area

* Better tooling for loading (and ideally, for creating/updating) the demo data

* In admin area, load the full dataset for user capabilities, feature flags,
  and possibly site settings, and stick them in some hashes, with some helper
  methods to check them. The menu already makes a crazy amount of hits on the
  db and there are still a load of 'feature hidden by flag/capability/etc'
  conditionals to implement.

* Add a polymorphic metatags model(s?)+concern+helper that can be added to anything
  that might want them for SEO (pages/sections, shop items/categories, etc)

* More themes!

* ¡español! :D

### Medium-ish

* Tests for rake tasks
  * https://thoughtbot.com/blog/test-rake-tasks-like-a-boss ? (old)

* Improve UX for slug auto-generation
  * Look at Fae CMS slugger: https://www.faecms.com/documentation/features-slugger

* A/B testing
  * Field Test: https://github.com/ankane/field_test

* Cookie consent
  * https://github.com/infinum/cookies_eu ?

* Replace hand-rolled slug generation with FriendlyId ?
  * https://norman.github.io/friendly_id


### Large-ish

* Surveys / Questionnaires

* GDPR compliance
  * https://github.com/prey/gdpr_rails

* Switch from ERB to handlebars or similar for main site templates

* Allow Page templates to be stored in database and edited in admin UI

* Allow in-situ editing of Page (and other?) content
  * Mercury: https://jejacks0n.github.io/mercury

* Replace hand-rolled trees and recursion (page sections, etc) with ClosureTree ?
  * https://github.com/ClosureTree/closure_tree


## Done / In Progress

See the [done](done.md) list for features from the original ShinyCMS that I have already implemented
in this version - as well as a few new ones that snuck in along the way - with notes on improvements
from the Perl version where applicable.

See the [in-progress](in-progress.md) list for features that I am currently working on
(with notes on where I'm up to, and links to useful docs).
