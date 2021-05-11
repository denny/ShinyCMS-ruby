# ShinyCMS Documentation

## Release Notes

This file contains information about changes (particularly breaking changes) between releases - with the most recent release first.

### 2021-05-07  21.05  May 2021: The 'Component With A View' release

GitHub tag: https://github.com/denny/ShinyCMS-ruby/releases/tag/v21.05

* Security updates:
    * Rails and related Action* gems had a cluster of CVE fixes this month

* Added:
    * [View Components][1] - used to rewrite the admin menu [PR #1096][2]
    * [mutant][3]- a mutation testing gem
    * config/initializers/shinycms.rb - allows the host app to configure:
        * The user model for ShinyCMS to use
        * The list model for ShinyNewsletters to use
    * .flayignore - causing a [dramatic improvement][4] in Ruby Critic scores
    * Blazer::ApplicationController in the host app, for Blazer to inherit from
    * Sentry gem and initializer

* Updated:
    * Split main site DiscussionsController, creating CommentsController too
    * Accessibility fixes for the Halcyonic theme [PR #1088][5] [PR #1091][6] [PR #1112][7]
        * Accessibly-hidden labels for form inputs
        * Text contrast ratios throughout
        * Editable image alt attributes added to index template
            * Changes to demo site data to go with this
    * The host app's ApplicationController is now free of confusing Blazer gank
    * Lots of gem version bumps, besides the aforementioned rails ones
        * Rubocop updates required some minor changes to code and config

* Removed:
    * Several packwerk todo files got removed by the configurable user model change
    * MainController in the host app, now that ApplicationController is usable
    * All the admin menu partials that got replaced by view components

Relatively quiet month, especially compared to the last few! I'm in the process of quitting one job and finding the next, so that's taken a lot of my time and energy. I'm happy with the first pass at adding view components though, expect more of those next month.

[1] https://github.com/github/view_component#readme
[2] https://github.com/denny/ShinyCMS-ruby/pull/1096
[3] https://github.com/mbj/mutant#readme
[4] https://shinycms.org/blog/2021/04/cheat-codes
[5] https://github.com/denny/ShinyCMS-ruby/pull/1088
[6] https://github.com/denny/ShinyCMS-ruby/pull/1091
[7] https://github.com/denny/ShinyCMS-ruby/pull/1112


### 2021-04-08  21.04  April 2021: The 'Respecting Boundaries' release

* GitHub tag: https://github.com/denny/ShinyCMS-ruby/releases/tag/v21.04

* Headline for this release:
    * Added [Packwerk](https://github.com/Shopify/packwerk/blob/main/README.md)
        * Helps define and enforce [plugin boundaries](https://github.com/denny/ShinyCMS-ruby/tree/main/docs/Developers/Plugins.md#boundaries)

* Also added:
    * Routes partials - building blocks for routes files
        * Intended to help with integrating ShinyCMS into pre-existing Rails apps
    * Bullet (warns about N+1 queries and related issues)
    * CircleCI config for Code Climate coverage reporting
    * Hugely improved base class for Mailers to inherit from
        * Again, should aid integration work, and legal compliance
    * Items extension for Pagy
    * `deprecated_references.yml`, which is Packwerk's equivalent of `rubocop_todo.yml`
        * Contains known boundary violations in the current code
        * These should be fixed in the code and then removed from the file
    * Some new classes have been added to enable plugins to talk to each other without violating boundaries, but mostly pre-existing helpers and concerns are handling this

* Moved:
    * From main_app to core plugin:
        * Most of the Gemfile
        * Some odds and ends of config (including main rubocop files)
        * rake tasks
        * Rails Email Preview
        * Base controllers used by gem Rails engines (e.g. Devise, Rails Email Preview, etc) (moved to ShinyCMS::Admin::Tools namespace)
    * To app/public folders:
        * Anything in any plugin (mostly core) that is used by another plugin

* Updated:
    * Base controllers used by gem Rails engines heavily rewritten (for easier re-use)
    * Tiny bumps for Ruby (from 3.0.0 to 3.0.1) and Rails (6.1.3 to 6.1.3.1)
    * Renamed `shiny:*` rake tasks to `shinycms:*`

* Removed:
    * Gemfile.lock files from plugins
    * Unused config files in main_app (anything that was all comments)
    * Disabled two Code Climate tools - spellcheck was removed I think, and Markdown Lint and I disagree on the value of vertical whitespace for readability in documentation :)


### 2021-03-01  21.03  March 2021: The 'Yo dawg I herd u liek CMS' release

* GitHub tag: https://github.com/denny/ShinyCMS-ruby/releases/tag/v21.03

* Headline for this release:
    * I moved almost all the code that was still in main_app, into a plugin! :-o

* Done:
    * The main_app is now called ShinyHostApp, and eventually it's _only_ job will be to load plugins - to demonstrate how (eventually) ShinyCMS could potentially be integrated within any existing Rails app
    * The code that was in main_app is now in the new ShinyCMS core plugin, which you can find in `plugins/ShinyCMS`
* To-do:
    * The config files haven't moved yet, that's my next big job
    * The documentation is partially updated, but I haven't gone through it all yet, so there may well be discrepancies here there and everywhere
    * Some of the engines from gems are still living in the main_app; a few of them didn't take well to being moved so I put them back there for now

* App and plugin versions:
    * All of the feature plugins, the new ShinyCMS core plugin, and the sort-of new ShinyHostApp, have all had their versions updated to 21.03 in this release - because as you can probably imagine, everything has had quite a lot of changes this last month!

* Other significant stuff:
    * I wrote a lot more code to support the Plugins 'infrastructure' or framework or whatever you'd call it. As well as the existing Plugin model (now ShinyCMS::Plugin, in the core plugin's models) there's also ShinyCMS::Plugins (plural) now - and a concern with some sugar/helper methods on top of that. All the code for dealing with collections of plugins moved into the new model, leaving the code that deals with individual plugins in the original class.

* Annoying side-effects of the main_app -> ShinyCMS plugin migration
    * A whole load of the moved files lost their git history at some point during the process; I guess GitHub decided that too many things had moved and so that must mean they'd all been deleted and new files created, despite the fact that I used the `git mv` command to do it all. I kept checking on things at the start and it was going okay, so I don't know what changed. I was quite a long way into the process when I did notice that it had dropped the history for a lot of stuff, so after a long pause to think it over, I decided to carry on rather than start again.

* Adventures in immutable data structures (and shiny emojis!)
    * I decided to use the [Persistent Diamond(https://gitlab.com/ivoanjo/persistent-dmnd) set of immutable data structures to underpin the Plugin(s) models and concern, which comes complete with a shiny little diamond emoji scattered around in the code (it's part of the method names, as well as the module name). One of my co-workers hates it, but I'm quite enjoying it... brightens my days up a bit :)

* Also added:
    * ShinySEO plugin; currently it just generates sitemap files (to feed into Google et al), but I already had some ideas for the future involving metatags helpers and concerns, so I figured an SEO plugin might be a good place for all that to end up.
    * [parallel_tests](https://github.com/grosser/parallel_tests#readme) - run the tests spread evenly across all your CPUs!
    * [rspec-instafail](https://github.com/grosser/rspec-instafail#readme) - displays fuller details of test failures while the rest of the suite continues to run in 'progress dots only' mode - so I can start on the fixes before it's even finished running :)
    * [A GitHub project board](https://github.com/denny/ShinyCMS-ruby/projects/1), for task-tracking (instead of the TODO and in-progress files)

* Updated:
    * LOTS OF DATABASE (TABLE NAME) CHANGES RELATED TO THE PLUGINIFICATION!!
    * After moving everything into the ShinyCMS plugin, I removed the leading 'Shiny' from a lot of helper and concern names, as they're namespaced now anyway
    * Made some changes around the comment-author area; it's a slightly more obvious role/duck-type now, with an AnonymousAuthor class joining in too
    * Pulled most of the code out of the demo-data rake task into a supporting module, and broke it up into smaller methods. Still needs more tests though.
    * I broke the plugin generator code up a bit too, but that's still pretty hideous. I got it down into the same complexity range as the rest of the system though, so it's not throwing the scale off in Ruby Critic's charts any more.
    * Rails made its way from 6.1.1 to 6.1.3 over the month (with some security advisories involved I believe, so make sure you're up to date)

* Removed:
    * Got rid of quite a lot of instance variable warnings from rubocop for the spec files - although there are still well over a hundred to go!
    * I both added _and_ removed the Airbrake gem; their free trial on Heroku turns out to be so feature-limited as to be useless. Coralogix and Bugsnag were both more impressive - Coralogix is very shiny, and Bugsnag has got some solid thinking behind it.

* Misc/stuff/FYI
    * I currently have a temporary branch running parallel to main with Pry removed, as Heroku seem to have a problem with Pry right now (or more accurately, with the coderay gem that it requires); I'll reintegrate everything as soon as it seems safe.


### 2021-02-01  21.02  February 2021: The 'quiet after the storm' release

* GitHub tag: https://github.com/denny/ShinyCMS-ruby/releases/tag/v21.02

* Plugin versions all updated to 21.02, as they all have changes since 21.01
    * Only minor changes in many though, often just the admin search method move

* Headlines:
    * Quiet month, after last month's upgrade extravaganza!
    * No really big changes this month; not that many smaller ones either :)

* Bug fixes:
    * Tags on hidden content no longer show up on tag list and tag cloud pages
        * Added ShinyTags concern and helpers to enable this
    * User profile instantiation in dev is more robust now (lazy-loading issue resolved)
    * More robust handling of 404s for non-HTML formats (usually hits from malware)

* Added:
    * ShinyUserAuthentication and ShinyUserAuthorization concerns
        * Splitting out auth code from User model
    * ShinyUserContent concern - splitting off relations to user-owned content
    * Links on user profiles, with a JS UI that very nearly works properly
    * ErrorController - more standard way to provide 'smart' 404 (etc) pages
        * Changes in several places to raise RecordNotFound to trigger 404 'neatly'
        * Added rspec support for optionally raising production-style errors in test env
    * Some support for manually overriding open/active status of admin menu items
    * lib/gemfile_plugins_helper.rb - new home for plugin-supporting methods from Gemfile
    * rubycritic - now uncommented in the Gemfile, reek fixed their ruby 3.0 issues
    * zxcvbn-ruby - intelligent password complexity checker
        * PasswordsController - JSON endpoint for getting password scores and advice
    * activerecord-analyze - adds .analyze method to AR objects, for investigating issues

* Updated:
    * Rails, from 6.1.0 to 6.1.1
    * Puma, from 5.1 to 5.2
    * Blazer, from 2.3.1 to 2.4.0
        * Fixed the issue with recent versions by overriding the clear_helpers method
    * MJMLSyntaxValidator rewritten - uses mjml directly rather than Mjml::Parser gem
    * Admin area 'quick search' methods moved from controllers to models
    * Minor code-quality tweaks in various admin controllers and some models
        * In controllers, mostly setting instance variables in before_actions
        * In models, several accessors changed from read/write to read-only
    * Split user session and user registration tests into two separate files

* Removed:
    * groupdate gem - this is related to Blazer, but wasn't being used
    * Various post-login redirect code, particularly for admins
        * It was architecturally horrible, and didn't offer enough value to justify that
    * user_profile factory - profiles are auto-created along with users now
        * There were quite a lot of very minor spec updates to adapt to this
    * Static 404 and 500 pages


### 2021-01-01  21.01  January 2021: 'Wishing you a Happy New Year, a Happy New Rails, and a Happy New Ruby!'

* GitHub tag: https://github.com/denny/ShinyCMS-ruby/releases/tag/v21.01

* Headlines:
    * Rails 6.1 !
    * Ruby 3.0 !!

* Also notable:
    * Pagination now uses Pagy rather than Kaminari
    * Travis CI removed, as they no longer support open source projects :(

* Possibly contentious Rubocop config change of the month ;)
    * Layout/HashAlignment -> EnforcedStyle: table

* Plugin versions all increased to 21.01

* Added
    * Pagy - new pagination gem, replacing Kaminari
    * rubocop-rspec
        * This triggered lots of minor changes to spec files, nothing major though
        * Still two types of warning left to address (see .rubocop_todo.yml)
    * rails_best_practices
    * rubycritic
        * Currently commented out in Gemfile due to Ruby 3.0 issues in its dependency chain, but config file included and all ready to go when reek catches up
    * Typo CI config (https://github.com/marketplace/typo-ci)
    * ActiveStorage added a new table, and a new column to an existing table
    * Database indexes on capabilities.category_id, comments.parent_id, and shiny_pages_sections.default_page_id

* Changed
    * As headlined, two particularly significant version bumps this month:
        * Rails, from 6.0 to 6.1
        * Ruby, from 2.7 to 3.0
            * This triggered downgrades in the codecov and fasterer gems
                * No noticeable impact from either of these
            * Needs an unreleased fix for ActiveRecord-session-store
                * Hence, this gem is currently installing from GitHub HEAD
    * Finished moving (almost) all theme files into the top-level /themes folder
        * Theme JavaScript files still not ideally located, but better than it was
            * Hooking up a theme with JavaScript requires creating a pack file at `/app/javascript/packs/{theme_name}.js`, which is clearly not how that boundary should work. The fix is probably themes-as-installable-gems. (Hold my beer?)
    * Human-readable names for capability categories now come via i18n rather than various model methods
    * ActiveRecord timestamp defaults overriden, to not include microseconds
    * In test and dev environment config:
        * Explicitly disabled precompiled asset check
            * This got rid of hopefully spurious errors about theme and plugin assets
        * Updated the name of an i18n-related setting

* Frozen
    * Blazer is currently locked to version 2.3.1, as 2.4.0 has a breaking change
        * https://github.com/ankane/blazer/issues/315
    * MJML is currently locked to version 4.7.1, as 4.8.0 has a breaking change

* Removed
    * As mentioned above, Travis CI has been removed
        * The company was sold and the new owners do not support open source :(
            * See https://travis-ci.community/t/10567 for more background
        * This means that there is currently no CI set up for older Ruby versions
    * Kaminari (pagination gem, replaced by Pagy)
    * The ShinyPaging concern (only existed to load Kaminari)


### 2020-12-03  20.12  December 2020: The 'ShinyAccess and ActiveStorage' Edition

* GitHub tag: https://github.com/denny/ShinyCMS-ruby/releases/tag/v20.12

* Plugin versions:
    * All plugin versions bumped to 20.12 - they've all had commits since 20.11 release

* BREAKING CHANGES
    * User profile data moved from users table into shiny_profiles_* tables
        * Migration only handles table structure - DATA MIGRATION IS NOT HANDLED
            * (When people are using the CMS in production, I'll write data migrations) :)
    * Feature Flag name changes:
        * recaptcha_for_registration -> recaptcha_for_registrations
        * profile_pages -> user_profiles
    * ShinyLists unsubscribe route changed from PUT to DELETE
    * Assets and JavaScript files for themes have moved from app/ to vendor/

* Fixes since 20.11
    * Fatal errors that could prevent the CMS from starting at all:
        * ShinyPlugin checks whether plugins exist before attempting to load them
        * ShinyPlugin de-duplicates SHINYCMS_PLUGINS before attempting to load them all
    * Security issues:
        * Admin area:
            * Authorisation check when accessing /admin/stats (Blazer)
        * Main site:
            * Don't add new comments (or show reply links & forms) if discussion is locked
    * Errors that only broke a specific page or feature-set:
        * Get rid of double '.../search/search' in admin area search forms
        * Displaying user profile pic from ActiveStorage works in local disk mode too
    * Wasted database space:
        * When dropping a comment flagged as 'blatant spam' by Akismet...
            * Don't create CommentAuthor and EmailRecipient records!
    * Lurkers (hadn't broken anything yet, but not the intended behaviour):
        * 'Page with all element types' factory was adding each type twice

* Added since 20.11
    * Gems:
        * Bugsnag gem
            * Monitoring and bug triage service
        * Cloudflare gem
            * Puts real IP address in request.ip, instead of Cloudflare proxy address
    * Plugins:
        * ShinyAccess
            * New plugin - adds basic ACL features for main site
                * Admin pages to add/remove Access Groups, and members of those groups
                * Main site helper to check access group membership, can be used to selectively show/hide content in any template
        * ShinyProfiles:
            * As part of separation from user accounts:
                * Main site page for users to edit their profile data
                * Admin area features for managing user profiles
        * ShinyNewsletters:
            * New rake task, to enqueue scheduled sends when they pass their send_at
    * Main app:
        * JSON endpoint to search usernames (used by ShinyAccess)
    * Support libs (helpers, concerns, etc):
        * ShinyTemplate / ShinyElement
            * Use ActiveStorage for image elements
        * Rake tasks:
            * `shiny:sessions:clean` for removing short (probably bot) session data
        * Utility scripts:
            * New dotenv wrapper scripts for dev environment (to pick up .env.*):
                * `tools/shiny-bundle-install` wraps `bundle install`
                    * Only matters if you don't want all of the plugins
                * `tools/shiny-sidekiq-dev` wraps `sidekiq`
                    * Only matters if you want to override default value of any ENV var mentioned in config/sidekiq.yml
    * Config:
        * Explicit config for HTML sanitizer - used when displaying blog posts etc
            * (full submitted HTML is stored, but output is heavily filtered)
            * Added a number of 'basic necessity' tags and attributes to the allow-list that weren't allowed through by default (e.g. img tag, class attribute)
        * More explicit config options to enable web stats and email open/click tracking
    * Documentation:
        * Moved content from docs/Developers/index.md to create docs/Contributing.md
            * (GitHub looks for the latter and automatically shares it with PR creators)
        * 'How to' guide for setting up a new site
        * Basic information about some supported/tested cloud hosting services
        * Stub doc for new ShinyAccess feature/plugin
        * Separate doc for rake tasks for developers (just shiny:demo:dump currently)
        * Notes on user personas (tl,dr: 'user' will probably (primarily) describe a different sub-group of CMS users to different types of developer)

* Changed since 20.11
    * Plugins:
        * ShinyProfiles:
            * Finish separating user profile data from user account data
        * ShinyBlog:
            * Change main site paging to use 'newer'/'older' links instead of full pager
    * Support libs (helpers, concerns, etc):
        * Move implementation of feature_flag_enabled? method from helper to model
        * Admin menu sections default to closed instead of open
        * Refactored plugin generator to make it more rubocop-compliant
            * Extracted lots of little blocks of functionality into their own methods
            * Moved a large chunk of the overall functionality into a new PluginBuilder file
    * Data:
        * Default data now includes a basic dashboard and charts for Blazer
        * Demo site data now includes the ActiveStorage tables
    * Tests:
        * Mocked Akismet gem .open and .check methods
            * No longer need a network connection for the tests to run
            * Tests aren't using up credits on my Akismet test account
    * Documentation:
        * Plugins: added details of 'special' integration views and helpers
        * Themes: updated paths for assets etc
        * ShinyNewsletters: added details of rake task for scheduled sends
        * Rake tasks: expand on purpose of each task
        * Updates to TODO/in-progress/done docs

* Removed since 20.11
    * User profile details removed from user account model (User.pm) and related code
        * (Now handled by ShinyProfiles plugin instead)


### 2020-11-09  20.11  November 2020: The 'tricky second album' release

* GitHub tag: https://github.com/denny/ShinyCMS-ruby/releases/tag/v20.11

* Plugin versions:
    * All raised to 20.11 - there have been code changes in every single plugin since the 20.10 release

* Updates and changes since 20.10:
    * General:
        * Ruby version: 2.7.1 -> 2.7.2
    * Rubocop:
        * Added some enforcement of preferred whitespace rules
        * Various updates to config for new versions with new cops
    * Configuration:
        * Added Setting.get_int method to get integer values from setting strings
        * Added Setting.true? method to get boolean results from 'true'/'false' setting strings
        * Started moving config that isn't secrets/credentials from ENV vars to Setting model
    * Supporting code (Helpers, Concerns, etc):
        * Added helper methods to abstract anywhere a main site view called a model
        * Renamed Plugin model to ShinyPlugin
        * Renamed FeatureFlagsHelper to ShinyFeatureFlagHelper
        * Renamed PagingHelper to ShinyPagingHelper
        * Renamed ElementsHelper to ShinyElementHelper
        * Refactored AkismetHelper to allow checking generic form submissions as well as comments
        * Pulled methods from ShinyMainSiteHelper into their own files:
            * Added ShinyConsentHelper for retrieving ConsentVersion details
            * Added ShinySettingsHelper for retrieving config settings
    * Comments/Discussions:
        * Changes to names of settings and code relating to who can post a comment (anon/etc)
        * Moved comment author details into a separate model
    * Mailer templates:
        * Added fancier MJML templates for discussion, user, and email recipient mailers

* New since 20.10:
    * General:
        * Added .env.test file, replacing some setup code in spec/spec_helper.rb
    * Gems:
        * acts_as_paranoid (add soft delete to models)
        * kaminari_route_prefix (fix kaminari pagination with Rails Engines routes)
        * sidekiq-status (display additional details in sidekiq web dashboard)
    * Supporting code (Helpers, Concerns, etc):
        * Added ShinyPaging concern, to set up kaminari pagination on a model
        * Added ShinySoftDelete concern, to set up acts_as_paranoid on a model
        * Added ShinyClassName concern, for easy access to an i18n-translated name for a type of site content from its model (e.g. 'blog post')
        * Added ShinyTemplateElement, to group common behaviour of template elements
        * Added ShinyPostAtomFeed and ShinyPostAtomFeedEntry, for constructing atom feeds
    * Admin Area:
        * Added pagination to index/list pages for most plugins/features
        * Added search to index/list pages for most plugins/features
        * Added new page for viewing and managing non-user-account Email Recipients
        * Added new 'Email' menu section, containing above page & mailer previews
        * Added menu item for Sidekiq web dashboard
    * Plugins:
        * ShinyBlog & ShinyNews
            * Added atom feed generation (can be written to local disk or AWS S3)
            * Added pagination on main site
        * ShinyForms
            * Added reCAPTCHA and Akismet checking for form submissions
        * ShinyNewsletters
            * Added 'drag to sort' in admin area, for:
                * Elements on Newsletter Edition and Newsletter Template edit pages
        * ShinyPages
            * Added 'drag to sort' in admin area, for:
                * Elements on Page and Page Template edit pages
                * Pages and Sections on main Page/Section list page (/admin/pages)

* Fixes since 20.10:
    * Fixed names of user mailer methods in various places (by adding '_instructions')
    * Added missing edit-capability templates in a few plugins, that were causing admins to lose capabilities when edited and saved via the web UI


### 2020-10-01  20.10  October 2020: The 'First Birthday' release

* This is the first release, in celebration of 1 whole year working on this project!

* GitHub tag: https://github.com/denny/ShinyCMS-ruby/releases/tag/v20.10
