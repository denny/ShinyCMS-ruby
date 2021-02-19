# ShinyCMS Developer Documentation

## Helpers

There are a number of helpers included with the project. These are intended to make it easier for people to build new features that work similarly to the existing features, from both a user and developer perspective.

In many cases the helper methods are there as an easy-to-use wrapper around the most common use cases for a more complex invocation of some model code - for example, `<% posts = recent_blog_posts( 5 ) %>` is the same as `<% posts = ShinyBlog::Post.readonly.recent.limit( 5 ) %>` - hopefully this will make it easier for people to build themes even if they're not familiar with ActiveRecord.

### In the core plugin

* MainSiteHelper         - common behaviour for main site controllers; includes many of the helpers below
* AdminAreaHelper        - common behaviour for admin area controllers
* ShinyMailerHelper      - common behaviour for Mailers

* ShinySiteNameHelper    - provides the <%= site_name %> method (included by MainSiteHelper and ShinyMailerHelper)

* ShinyPluginHelper      - methods wrapping common uses (in views) of the Plugin model

* DateHelper             - turns model timestamps into human-friendly time and date strings
* DiscussionHelper       - discussion-related settings and searches
* ShinyElementHelper     - methods related to *Element models
* ShinyFeatureFlagHelper - check and enforce feature flags
* ShinyPagingHelper      - methods to help with pagination
* ShinyUserHelper        - user-capability checks and profile link generation

* AkismetHelper          - methods related to the Akismet spam-flagging service
* RecaptchaHelper        - methods related to Google's reCAPTCHA bot detection service
* SidekiqHelper          - method to check whether Sidekiq job queues are enabled

At some point in the future, most of these Helpers will probably move into some sort of ShinyTools plugin or plugins (which can then be depended on by whichever other plugins need them), as part of the long-term plan to move most or all of the main app code into plugins.

### In plugins

* ShinyPages::MainSiteHelper    - page and page sections (default_page, default_section, etc)
* ShinyInserts::MainSiteHelper  - get the content for an insert element, or check its type
* ShinyForms::MainSiteHelper    - look up a form by slug

* ShinySearch::MainSiteHelper   - check which search backends are enabled, and related methods

* ShinyBlog::MainSiteHelper     - get most recent (published) posts, for use in sidebars etc
* ShinyNews::MainSiteHelper     - get most recent (published) posts, for use in sidebars etc

* ShinyLists::MainSiteHelper    - look up a mailing list by slug (or fall back to most recent list)

* ShinyProfiles::MainSiteHelper - find plugins with user-content partials to include on profile pages
