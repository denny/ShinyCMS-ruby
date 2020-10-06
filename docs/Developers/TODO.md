# ShinyCMS: TODO

## Fixes and refactoring of code already written - to do next/soon

* Investigate and fix blank email issue

* Move most of this list into GitHub issues
  * Put the whole 'planned features' TODO list in there?

* Figure out what the bug is with paging on newsletter editions admin index page
  * (And, at a guess from the error message, any and all nested admin index pages)

* Write mailer tests instead of hitting mailers indirectly from request specs (Forms; any others?)

* Re-think mailer preview features
  * Can I use https://guides.rubyonrails.org/action_mailer_basics.html#previewing-emails instead of REP?

* Make a generic sidebar template that renders any partials in a specified directory

* Add subscription-management links to list emails

* Replace everywhere a model class is named in a template, with a helper method

* Change admin settings page to get descriptions in same 'stripe' as the thing they describe

* Highlight section name in admin area menu when on a page which isn't in the menu
  (e.g. 'Edit page', clicking around in Blazer, etc)
* Relatedly; jump admin menu to current section with an anchor

* Catch Pundit::NotAuthorizedError and output `head :unauthorized` (currently 500s I think?)

* Track down untranslated strings and add them to locale files
  * Check core and plugins; templates, controllers, and models; admin area, main site, and themes
  * Frequent offenders: column headings on index pages, input labels on new/edit forms

* Make sure concerns are used everywhere they could/should be, and that the shared examples
  are used to test that the concerns are doing the right thing in each place they get used.

* Flesh out search methods in admin controllers
  * Make sure they check against all useful attributes
  * Bonus points for checking against associated entities, e.g. subscription->subscriber->name

### Non-trivial

* Can I merge EmailRecipient, CommentAuthor, and VotableIP into a single Visitor model?
  * Think carefully about privacy implications of linking previous actions to current visitor

* ShowHide could be abstracted more AND be more useful, as a polymorphic acts_as_showable
  sort of thing - giving us show_on( :site ), show_in( :menus ), show_on( :sitemap ), etc


## Features the Perl version has, which the Ruby version doesn't. Yet. :)

### Small-ish

* Some sort of file-picker (for image elements, CKEditor, etc)
  * https://ckeditor.com/docs/ckeditor5/latest/features/image-upload/ckfinder.html

* Site map

* Affiliate cookie

### Medium-ish

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


## New features that I'd like to add / features that I'd like to totally rebuild

### Small-ish

* 'Deploy to Heroku' button
  * https://devcenter.heroku.com/articles/heroku-button

* 2FA
  * https://github.com/tinfoil/devise-two-factor

* Allow an EmailRecipient to reset their token (in case they forward an email containing it to somebody else)

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

* Add tests for form actions being what they're supposed to be on new/edit pages,
  and for delete links being correct on list pages (to catch path helper issues)

### Medium-ish

* Add acts_as_paranoid to everything (soft delete)
  * https://github.com/ActsAsParanoid/acts_as_paranoid

* Add folding to page sections on /admin/pages
  * Add 'fold all' and 'open all' options (here, and anywhere else that has folding too)
  * Decide 'intelligently' whether to fold all/none/some
    * (e.g. if there are >20 pages in total, fold any section containing >10 pages; if there are >10 sections and >100 pages in total, fold all sections; etc)

* When people post a comment or subscribe to a list without being logged in, offer to create an account for them?

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

* Allow theme templates to be stored in database and edited in admin UI
* Allow theme templates to be imported from an S3 folder

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
