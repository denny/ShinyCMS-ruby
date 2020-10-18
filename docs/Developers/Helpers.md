# ShinyCMS Developer Documentation

## Helpers

There are several helpers included with the project. These are intended to make it easier for people to build new features that work similarly to the existing features, from both a user and developer perspective.

### In the main app

AdminAreaHelper - included by AdminController
ShinyMainSiteHelper - included by MainSiteController, and includes several of the helpers below

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

### In plugins

plugins/ShinyPages/app/helpers/shiny_pages/main_site_helper.rb
plugins/ShinyForms/app/helpers/shiny_forms/main_site_helper.rb
plugins/ShinyInserts/app/helpers/shiny_inserts/main_site_helper.rb

plugins/ShinyBlog/app/helpers/shiny_blog/main_site_helper.rb
plugins/ShinyNews/app/helpers/shiny_news/main_site_helper.rb

plugins/ShinyLists/app/helpers/shiny_lists/main_site_helper.rb
plugins/ShinyNewsletters/app/helpers/shiny_newsletters/application_helper.rb

plugins/ShinyProfiles/app/helpers/shiny_profiles/main_site_helper.rb
plugins/ShinySearch/app/helpers/shiny_search/main_site_helper.rb
