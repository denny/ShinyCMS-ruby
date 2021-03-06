# ShinyCMS Developer Documentation

## Supporting code: helpers

Most of the helpers provide formatters, presentation logic, or wrappers around common uses of a model from a view (adding some much-needed isolation/abstraction in this last case).

Hopefully they will make it easier for people to build themes even if they're not hugely familiar with ActiveRecord). For example, this code using a helper:
`<% posts = recent_blog_posts( 5 ) %>`
returns the same results as this code using a model:
`<% posts = ShinyBlog::Post.readonly.recent.limit( 5 ) %>`


### From core plugin

* MainSiteHelper     - no code, but includes all the helpers below that are useful on the main site

* AdminAreaHelper    - helper methods for admin area views and controllers
* MailerHelper       - helper methods for mailers

* PluginsHelper      - the `plugin_loaded?` method

* DatesHelper        - turn DateTime objects into human-readable dates and times
* DiscussionsHelper  - methods to get discussion settings and fetch recent comments
* ElementsHelper     - the `element_types` method, for populating drop-down menu
* FeatureFlagsHelper - the `feature_enabled?` method
* PagingHelper       - methods to help with pagination
* SiteNameHelper     - the `site_name` method
* UsersHelper        - provides user-capability checks and profile link generation

* AkismetHelper      - methods related to the Akismet spam-flagging service
* RecaptchaHelper    - methods related to Google's reCAPTCHA bot detection service


### From feature plugins

*Methods defined in feature plugin helpers called `MainSiteHelper` are automatically loaded and made available to views throughout the entire CMS.*

* ShinyBlog::MainSiteHelper     - get most recent published posts, for use in sidebars etc

* ShinyForms::MainSiteHelper    - look up a form by slug

* ShinyInserts::MainSiteHelper  - get the content for an insert element, or check its type

* ShinyLists::MainSiteHelper    - look up a mailing list by slug (or fall back to most recent list)

* ShinyNews::MainSiteHelper     - get most recent published posts, for use in sidebars etc

* ShinyPages::MainSiteHelper    - page and page sections (default_page, default_section, etc)

* ShinyProfiles::MainSiteHelper - find plugins with user-content partials to include on profile pages

* ShinySearch::MainSiteHelper   - check which search backends are enabled, and related methods
