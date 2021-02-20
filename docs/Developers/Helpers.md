# ShinyCMS Developer Documentation

## Helpers

There are a number of helpers included with the project. These have two main purposes:

1. They provide common usage patterns. This should make it easier for plugin developers to build new features that [work similarly](https://en.wikipedia.org/wiki/Principle_of_least_astonishment) to the existing features.

2. They provide easy-to-use wrappers around common uses of a model from a view (at the same time as adding some isolation and abstraction for such interactions).

Hopefully the view helpers will make it easier for people to build themes even if they're not hugely familiar with ActiveRecord). For example, this code using a helper:
`<% posts = recent_blog_posts( 5 ) %>`
returns the same results as this code using a model:
`<% posts = ShinyBlog::Post.readonly.recent.limit( 5 ) %>`

### From core plugin

* MainSiteHelper    - useful methods for main site views - includes many of the helpers below
* AdminAreaHelper   - useful methods for admin area views
* MailerHelper      - useful methods for mailers

* PluginHelper      - provides the `plugin_loaded?` method

* DateHelper        - turns DateTime objects into human-readable dates and times
* DiscussionHelper  - discussion-related settings and searches
* ElementHelper     - provides `element_types` method, for populating drop-down menu

* ShinyFeatureFlagHelper - check and enforce feature flags
* ShinyPagingHelper      - methods to help with pagination
* ShinySiteNameHelper    - provides the `site_name` method - included by MainSiteHelper and ShinyMailerHelper
* ShinyUserHelper        - user-capability checks and profile link generation

* AkismetHelper          - methods related to the Akismet spam-flagging service
* RecaptchaHelper        - methods related to Google's reCAPTCHA bot detection service
* SidekiqHelper          - method to check whether Sidekiq job queues are enabled

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
