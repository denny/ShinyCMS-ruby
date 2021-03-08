# ShinyCMS Developer Notes

## Bullet recommendations

Docs: https://github.com/flyerhzm/bullet#log


### N+1 and counter_cache warnings

None. Which feels slightly suspicious; it seems unlikely that I didn't slip up anywhere.


### Use eager loading

GET /newsletters
USE eager loading detected
  ShinyNewsletters::Send => [:edition]
  Add to your query: .includes([:edition])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/app/views/shiny_newsletters/newsletters/index.html.erb:14:in `block in _plugins__hiny_ewsletters_app_views_shiny_newsletters_newsletters_index_html_erb___1313984291077648699_509180'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/app/views/shiny_newsletters/newsletters/index.html.erb:12:in `each'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/app/views/shiny_newsletters/newsletters/index.html.erb:12:in `_plugins__hiny_ewsletters_app_views_shiny_newsletters_newsletters_index_html_erb___1313984291077648699_509180'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/spec/requests/shiny_newsletters/newsletters_controller_spec.rb:28:in `block (3 levels) in <top (required)>'

GET /newsletters
USE eager loading detected
  ShinyNewsletters::Send => [:edition]
  Add to your query: .includes([:edition])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/app/views/shiny_newsletters/newsletters/index.html.erb:14:in `block in _plugins__hiny_ewsletters_app_views_shiny_newsletters_newsletters_index_html_erb___1313984291077648699_509180'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/app/views/shiny_newsletters/newsletters/index.html.erb:12:in `each'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/app/views/shiny_newsletters/newsletters/index.html.erb:12:in `_plugins__hiny_ewsletters_app_views_shiny_newsletters_newsletters_index_html_erb___1313984291077648699_509180'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/spec/requests/shiny_newsletters/newsletters_controller_spec.rb:48:in `block (4 levels) in <top (required)>'

GET /admin/newsletters/sends
USE eager loading detected
  ShinyNewsletters::Send => [:list]
  Add to your query: .includes([:list])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/app/views/shiny_newsletters/admin/sends/_sends.html.erb:23:in `block in _plugins__hiny_ewsletters_app_views_shiny_newsletters_admin_sends__sends_html_erb__1293562048999176340_469980'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/app/views/shiny_newsletters/admin/sends/_sends.html.erb:17:in `_plugins__hiny_ewsletters_app_views_shiny_newsletters_admin_sends__sends_html_erb__1293562048999176340_469980'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/app/views/shiny_newsletters/admin/sends/index.html.erb:14:in `_plugins__hiny_ewsletters_app_views_shiny_newsletters_admin_sends_index_html_erb___1839985450544989618_469920'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/spec/requests/shiny_newsletters/admin/sends_controller_spec.rb:213:in `block (3 levels) in <top (required)>'


### Avoid eager loading

GET /blog/2021/03/kakistocrat
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/admin/comments_controller_spec.rb:165:in `block (3 levels) in <top (required)>'

GET /blog/2021/03/nervous-energy
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/admin/comments_controller_spec.rb:182:in `block (3 levels) in <top (required)>'

GET /news/2021/03/arrested-development
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/admin/comments_controller_spec.rb:196:in `block (3 levels) in <top (required)>'

GET /news/2021/03/t3ou-4
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/admin/comments_controller_spec.rb:212:in `block (3 levels) in <top (required)>'

GET /blog/2021/03/thank-you-and-goodnight
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/admin/comments_controller_spec.rb:226:in `block (3 levels) in <top (required)>'

GET /discussion/54
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/admin/discussions_controller_spec.rb:51:in `block (3 levels) in <top (required)>'

GET /discussion/55
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/admin/discussions_controller_spec.rb:64:in `block (3 levels) in <top (required)>'

GET /discussion/56
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/admin/discussions_controller_spec.rb:80:in `block (3 levels) in <top (required)>'

GET /news/2021/03/teething-problems
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:45:in `block (3 levels) in <top (required)>'

GET /discussion/61
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:75:in `block (3 levels) in <top (required)>'

GET /discussion/63/2
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:94:in `block (3 levels) in <top (required)>'

GET /discussion/65
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:125:in `block (3 levels) in <top (required)>'

GET /discussion/66
USE eager loading detected
  ShinyCMS::User => [:profile]
  Add to your query: .includes([:profile])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/app/models/shinycms/user.rb:41:in `name'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/app/helpers/shinycms/users_helper.rb:27:in `user_profile_link'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/app/views/shinycms/discussions/comment/_posted_by.html.erb:5:in `_plugins__hiny____app_views_shinycms_discussions_comment__posted_by_html_erb___4188795360876021136_321580'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/app/views/shinycms/discussions/comment/_header.erb:10:in `_plugins__hiny____app_views_shinycms_discussions_comment__header_erb___2556141725059801205_321560'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/app/views/shinycms/discussions/_comment.html.erb:4:in `_plugins__hiny____app_views_shinycms_discussions__comment_html_erb___2468144538814618845_321520'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/app/views/shinycms/discussions/_comment_thread.html.erb:4:in `_plugins__hiny____app_views_shinycms_discussions__comment_thread_html_erb__2061937146636906666_321500'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/app/views/shinycms/discussions/_top_level.html.erb:3:in `block in _plugins__hiny____app_views_shinycms_discussions__top_level_html_erb___1714185828006341270_321400'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/app/views/shinycms/discussions/_top_level.html.erb:1:in `_plugins__hiny____app_views_shinycms_discussions__top_level_html_erb___1714185828006341270_321400'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/app/views/shinycms/discussions/show.html.erb:4:in `_plugins__hiny____app_views_shinycms_discussions_show_html_erb__4004307419795142360_259880'
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:148:in `block (3 levels) in <top (required)>'

GET /discussion/66
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:148:in `block (3 levels) in <top (required)>'

GET /discussion/67
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:170:in `block (3 levels) in <top (required)>'

POST /discussion/68
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:178:in `block (3 levels) in <top (required)>'

GET /discussion/69
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:207:in `block (3 levels) in <top (required)>'

GET /discussion/70
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:233:in `block (3 levels) in <top (required)>'

POST /discussion/71
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:256:in `block (3 levels) in <top (required)>'

POST /discussion/72/2
AVOID eager loading detected
  ShinyCMS::Comment => [:author]
  Remove from your query: .includes([:author])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:280:in `block (3 levels) in <top (required)>'

GET /discussion/72
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:289:in `block (3 levels) in <top (required)>'

POST /discussion/73/2
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/discussions_controller_spec.rb:297:in `block (3 levels) in <top (required)>'

GET /news/2021/03/thorough-but-unreliable
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/votes_controller_spec.rb:32:in `block (3 levels) in <top (required)>'

GET /news/2021/03/thorough-but-unreliable
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/votes_controller_spec.rb:41:in `block (3 levels) in <top (required)>'

GET /news/2021/03/excuses-and-accusations
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/votes_controller_spec.rb:57:in `block (3 levels) in <top (required)>'

GET /news/2021/03/meatfucker
AVOID eager loading detected
  ShinyCMS::Comment => [:comments]
  Remove from your query: .includes([:comments])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyCMS/spec/requests/shinycms/votes_controller_spec.rb:74:in `block (3 levels) in <top (required)>'

POST /list/appeal-to-reason/subscribe
AVOID eager loading detected
  ShinyLists::Subscription => [:subscriber]
  Remove from your query: .includes([:subscriber])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyLists/spec/requests/shiny_lists/subscriptions_controller_spec.rb:66:in `block (3 levels) in <top (required)>'

POST /list/grey-area/subscribe
AVOID eager loading detected
  ShinyLists::Subscription => [:subscriber]
  Remove from your query: .includes([:subscriber])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyLists/spec/requests/shiny_lists/subscriptions_controller_spec.rb:85:in `block (3 levels) in <top (required)>'

POST /admin/newsletters/editions
AVOID eager loading detected
  ShinyNewsletters::TemplateElement => [:image_attachment]
  Remove from your query: .includes([:image_attachment])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/spec/requests/shiny_newsletters/admin/editions_controller_spec.rb:61:in `block (3 levels) in <top (required)>'

POST /admin/newsletters/editions
AVOID eager loading detected
  ShinyNewsletters::TemplateElement => [:image_attachment]
  Remove from your query: .includes([:image_attachment])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyNewsletters/spec/requests/shiny_newsletters/admin/editions_controller_spec.rb:108:in `block (3 levels) in <top (required)>'

POST /admin/pages
AVOID eager loading detected
  ShinyPages::TemplateElement => [:image_attachment]
  Remove from your query: .includes([:image_attachment])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyPages/spec/requests/shiny_pages/admin/pages_controller_spec.rb:83:in `block (3 levels) in <top (required)>'

POST /admin/pages
AVOID eager loading detected
  ShinyPages::TemplateElement => [:image_attachment]
  Remove from your query: .includes([:image_attachment])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyPages/spec/requests/shiny_pages/admin/pages_controller_spec.rb:101:in `block (3 levels) in <top (required)>'

GET /admin/profiles/697/edit
AVOID eager loading detected
  ShinyProfiles::Profile => [:links]
  Remove from your query: .includes([:links])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyProfiles/spec/requests/shiny_profiles/admin/profiles_controller_spec.rb:22:in `block (3 levels) in <top (required)>'

PUT /admin/profiles/699
AVOID eager loading detected
  ShinyProfiles::Profile => [:links]
  Remove from your query: .includes([:links])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyProfiles/spec/requests/shiny_profiles/admin/profiles_controller_spec.rb:35:in `block (3 levels) in <top (required)>'

GET /admin/profiles/699/edit
AVOID eager loading detected
  ShinyProfiles::Profile => [:links]
  Remove from your query: .includes([:links])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyProfiles/spec/requests/shiny_profiles/admin/profiles_controller_spec.rb:43:in `block (3 levels) in <top (required)>'

GET /profile/marlin/edit
AVOID eager loading detected
  ShinyProfiles::Profile => [:links, :profile_pic_attachment]
  Remove from your query: .includes([:links, :profile_pic_attachment])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyProfiles/spec/requests/shiny_profiles/profiles_controller_spec.rb:67:in `block (4 levels) in <top (required)>'

PUT /profile/ladawn.price
AVOID eager loading detected
  ShinyProfiles::Profile => [:links]
  Remove from your query: .includes([:links])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyProfiles/spec/requests/shiny_profiles/profiles_controller_spec.rb:114:in `block (3 levels) in <top (required)>'

PUT /profile/carlos_conn
AVOID eager loading detected
  ShinyProfiles::Profile => [:links]
  Remove from your query: .includes([:links])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyProfiles/spec/requests/shiny_profiles/profiles_controller_spec.rb:159:in `block (3 levels) in <top (required)>'

PUT /profile/carmina_glover
AVOID eager loading detected
  ShinyProfiles::Profile => [:links, :profile_pic_attachment]
  Remove from your query: .includes([:links, :profile_pic_attachment])
Call stack
  /home/denny/code/denny/ShinyCMS-ruby/plugins/ShinyProfiles/spec/requests/shiny_profiles/profiles_controller_spec.rb:136:in `block (4 levels) in <top (required)>'
