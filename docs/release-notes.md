# ShinyCMS Documentation

## Release Notes

This file contains information about changes (particularly breaking changes) between releases - with the most recent release first.


### 2020-11-09 - v20.11 - November 2020: The 'tricky second album' release

    * Plugin versions:
        * There have been code changes in every plugin since 20.10 release, so their version numbers have all been bumped to 20.11 too

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
                * Deprecated ENV vars:
                    * TODO!!
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


### 2020-10-01 - v20.10 - October 2020: The 'First Birthday' release

    * This is the first release, tagged v20.10 on GitHub:
        * https://github.com/denny/ShinyCMS-ruby/releases/tag/v20.10
