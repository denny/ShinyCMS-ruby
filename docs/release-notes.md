# ShinyCMS Documentation

## Release Notes

This file contains information about changes (particularly breaking changes) between releases - with the most recent release first.


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
