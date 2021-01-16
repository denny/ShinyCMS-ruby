# ShinyCMS Developer Documentation

## TODO

### Current / next / urgent

* Finish adding support for links on user profiles
    * Check whether creating a user account creates a user profile

* Investigate: tests of MJML mailers (Forms, Newsletters, etc) throw this when run offline:
    * "Mjml: warning You don't appear to have an internet connection. Try the --offline flag to use the cache for registry queries."
        * Newsletter plugin tests tend to top the 'slowest tests' list - related?


## Features the Perl version has, which the Ruby version doesn't. Yet. :)

### Small-ish

* Add 'items' extra to Pagy: https://ddnexus.github.io/pagy/extras/items.html
    * Allow pagination URLs to specify /items/N instead of ?items=N

* Site map / sitemaps
    * 1. User-facing type - tie into search, tags, 404, etc
    * 2. SEO type: https://github.com/kjvarga/sitemap_generator ?

* Affiliate cookie

### Medium-ish

* Some sort of file-picker for CKEditor
    * https://ckeditor.com/docs/ckeditor5/latest/Features/MainApp/image-upload/ckfinder.html

* Polls

### Large-ish

* Access-controlled file downloads
    * Can this be done with tokenised AWS links? (Probably)
    * If so, do I want that vendor lock-in? (Probably not)

* Online shop

* Autoresponders

* Email sequences - define a series of emails, to be sent at defined intervals

* Payment handling plugins
    * Pay to join an access control group - AKA 'paid membership'
    * Pay to receive an email sequence - AKA 'buy a training course'

* Forums

* Event listings


## New features that I'd like to add / features that I'd like to totally rebuild

### Small-ish

* Handle timezones
    * https://planetruby.github.io/gems/2020/01-local-time
    * https://github.com/basecamp/local_time#readme
    * https://prathamesh.tech/2019/07/11/use-time-use_zone-to-navigate-timezones
    * https://api.rubyonrails.org/classes/Time.html#method-c-use_zone
    * https://api.rubyonrails.org/classes/ActiveRecord/Timestamp.html

* Add 'unsubscribe reason' to ShinyLists

* Add a 'save form submission to database' form handler

* Make a generic sidebar template that renders any partials in a specified directory

* Add links to the in-page alerts, where helpful? e.g. "You must <a href="/login">log in</a> first"
    * https://guides.rubyonrails.org/i18n.html#using-safe-html-translations
    * https://www.ruby-toolbox.com/projects/it

* Re-assess use of helpers (vs models/libs/whatever) for Akismet and reCaptcha (and others?)

* On email recipients admin page, link to a summary of their comments and newsletter subscriptions (if any exist)

* Allow an EmailRecipient to reset their token (in case they forward an email containing it to somebody else)

* When not-logged-in users post a comment or subscribe to a list, offer to create an account for them

* 'Deploy to Heroku' button: https://devcenter.heroku.com/articles/heroku-button

* 2FA: https://github.com/tinfoil/devise-two-factor

* Check site config for internal consistency on startup
    * e.g. if reCAPTCHA is enabled for registrations, the reCAPTCHA keys must be set

* Configurable (per-site and per-user) menu order in admin area
    * ( Per-site is currently partially possible, by changing the order plugins appear in ENV['SHINYCMS_PLUGINS'] )

* In admin area, load the full dataset for user capabilities, feature flags,
  and possibly site settings, and stick them in some hashes, with some helper
  methods to check them. The menu already makes a crazy amount of hits on the
  db and there are still a load of 'feature hidden by flag/capability/etc'
  conditionals to implement.

* ¡español! :D
    * Bonus points: https://www.ruby-toolbox.com/projects/route_translator
    * Possibly interesting at same time: https://www.ruby-toolbox.com/projects/rack-user-locale

* Add tests for form actions being what they're supposed to be on new/edit pages,
  and for delete links being correct on list pages (to catch path helper issues)

* Make textarea inputs grow as needed
    * http://www.cryer.co.uk/resources/javascript/script21_auto_grow_text_box.htm

* Switch pagination to use JS helpers, to give site builders more flexibility?

* Delete ahoy and session data when Akismet reports blatant spam? (make configurable)

### Medium-ish

* Refactor show/hide/visible/published/etc stuff
    * ShowHide could become a polymorphic acts_as_showable sort of thing?
        * show_on( :site ), show_in( :menus ), show_on( :sitemap ), etc

* More themes!

* Add folding to page sections on /admin/pages
    * Add 'fold all' and 'open all' options (here, and anywhere else that has folding too)
    * Decide 'intelligently' whether to fold all/none/some
        * (e.g. if there are >20 pages in total, fold any section containing >10 pages; if there are >10 sections and >100 pages in total, fold all sections; etc)

* Blazer:
    * Investigate alternatives? https://github.com/ankane/blazer/pull/316 :(
        * daru-view ?? https://github.com/SciRuby/daru-view#readme
    * Fix admin ACL; currently if you can view, you can add/update/delete too
        * Wrap in a thin ShinyStats plugin, to give it standard auth and feature flagging

* Add a polymorphic metatags model+helpers so they can be added to anything that might want them for SEO
    * pages/sections, shop items/categories, etc

* Multi-channel notifications: https://github.com/excid3/noticed#readme

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

* Fix geolocation (for web stats) via Cloudflare?
    * https://support.cloudflare.com/hc/en-us/articles/200168236-Configuring-Cloudflare-IP-Geolocation

### Large-ish

* Investigate RBS - https://github.com/ruby/rbs#readme
    * https://honeyryderchuck.gitlab.io/httpx/2020/10/16/rbs-duck-typing-at-httpx.html

* View Components sound very interesting... https://viewcomponent.org

* Re-think mailer preview features
    * Can I use https://guides.rubyonrails.org/action_mailer_basics.html#previewing-emails instead of REP?

* Invites: https://github.com/scambra/devise_invitable#readme

* Image galleries / multimedia galleries / etc

* Can I merge EmailRecipient, CommentAuthor, and VotableIP into a single Visitor model?
    * Think carefully about privacy implications of linking previous actions to current visitor

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

* Wiki?
    * Integrate an existing project? https://www.ruby-toolbox.com/categories/wiki_apps

* Integrate a static site generator? https://www.ruby-toolbox.com/categories/static_website_generation

* Run multiple ShinySites from one ShinyCMS installation?
    * https://www.ruby-toolbox.com/categories/Multitenancy


## Done / In Progress

See the [done](done.md) list for features from the original ShinyCMS that I have already implemented in this version - as well as a few new ones that snuck in along the way - with notes on improvements from the Perl version where applicable.

See the [in-progress](in-progress.md) list for features that I am currently working on (with notes on where I'm up to, links to useful docs, etc).
