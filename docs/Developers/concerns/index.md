# ShinyCMS Developer Documentation

## Concerns and helpers

There are a number of concerns and helpers intended to make it easier to build new features that work similarly to existing features from both a user and developer perspective.

### Concerns

* ShinyDemoDataProvider - for models that can provide data to the demo site
* ShinyEmail - for models with email attributes
* ShinyName - for models with an internal name and a public name
* ShinyShowHide - for models for things that can be visible or hidden on the site
* ShinyTeaser - for models that want to generate a short 'teaser' of a longer post
* ShinyToken - for models with UUID token attributes

* ShinySlug - for models with a URL slug attribute
* ShinySlugInMonth - includes ShinySlug, but only enforces uniqueness within a month
* ShinySlugInSection - includes ShinySlug, but only enforces uniqueness within a section

* ShinyPost - for models with a 'post' format (e.g. blog posts, news posts) (including this will automatically include ShinyShowHide, ShinySlugInMonth, and ShinyTeaser)

* ShinyWithTemplate - for models that use a template for layout (e.g. pages, newsletter editions)
* ShinyElement - for models that are elements of templated content

* ShinyTemplate - for models that are a layout template (e.g. page templates, newsletter templates)
* ShinyHTMLTemplate - for models that are an HTML-based template (includes ShinyTemplate)
* ShinyMJMLTemplate - for models that are an MJML-based template (includes ShinyTemplate)
* ShinyTemplateElement - for models that are elements of a template (includes ShinyElement)

#### In plugins

* ShinySearch::Searchable - for models that want to be discoverable by the search feature


### Helpers

ShinyMainSiteHelper - included by MainSiteController, and includes several of the helpers below
AdminAreaHelper - included by AdminController

shiny_date_helper.rb
shiny_discussion_helper.rb
elements_helper.rb
feature_flags_helper.rb
shiny_mailer_helper.rb
shiny_paging_helper.rb
shiny_plugin_helper.rb
shiny_site_name_helper.rb
shiny_user_helper.rb

AkismetHelper - methods for dealing with Akismet's spam-flagging service
RecaptchaHelper - methods for dealing with Google's reCAPTCHA bot detection service
Sidekiq - methods for dealing with Sidekiq job queues

#### In plugins

plugins/ShinyBlog/app/helpers/shiny_blog/main_site_helper.rb
plugins/ShinyForms/app/helpers/shiny_forms/main_site_helper.rb
plugins/ShinyInserts/app/helpers/shiny_inserts/main_site_helper.rb
plugins/ShinyLists/app/helpers/shiny_lists/main_site_helper.rb
plugins/ShinyNews/app/helpers/shiny_news/main_site_helper.rb
plugins/ShinyNewsletters/app/helpers/shiny_newsletters/application_helper.rb
plugins/ShinyPages/app/helpers/shiny_pages/main_site_helper.rb
plugins/ShinyProfiles/app/helpers/shiny_profiles/main_site_helper.rb
plugins/ShinySearch/app/helpers/shiny_search/main_site_helper.rb
