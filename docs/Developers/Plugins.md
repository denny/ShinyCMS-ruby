# ShinyCMS Developer Documentation

## Writing a new plugin

### Generator

Move into the base directory of your copy of the ShinyCMS code:
`cd ShinyCMS`

Then, run the plugin generator:
`rails g shiny:plugin plugins/ShinyThing`

(Currently your plugin must be named Shiny{Something} for some filepath-dependent hacks to work.)

The plugin generator is a cut-down version of the standard Rails Engine generator (rails new plugin --mountable) with some added boilerplate to fit the resulting plugin into ShinyCMS. You can pass it flags which the rails plugin generator understands, to skip features that your plugin doesn't need - e.g:
`rails g shiny:plugin --skip-action-mailer --skip-action-mailbox --skip-action-cable plugins/ShinyThing`


### Documentation

You should put the appropriate details in `plugins/ShinyThing/shiny_thing.gemspec`, and you'll probably want to edit `plugins/ShinyThing/README.md` as well.


### Tests

Your tests go in `plugins/ShinyThing/spec/` and you can run them from the ShinyCMS root directory:
```
rspec plugins/ShinyThing  # to run tests for just your new plugin
rspec spec plugins  # to run tests for the main app and all plugins
```


### Code!

Most of your code probably goes in `plugins/ShinyThing/app/`, with routes and locale files in `plugins/ShinyThing/config/`

#### Special files

Some special files are looked for and (if they exist) loaded as specified below, to help your plugin hook into the CMS:

Views (partials):
* `ShinyThing/app/views/shiny_thing/menu/_section.html.erb` will be rendered as a new section in the main site menu
* `ShinyThing/app/views/shiny_thing/profile/_content.html.erb` will be rendered in the 'content posted by this user' section of the user's profile page, if the ShinyProfiles plugin is loaded
* `ShinyThing/app/views/shiny_thing/search/result/shiny_thing/_model_name.html.erb` will be rendered when content from your plugin appears in the search results, if the ShinySearch plugin is loaded and you have hooked your models into it
* `ShinyThing/app/views/shiny_thing/admin/menu/_section.html.erb` will be rendered as a new section in the admin area menu
* `ShinyThing/app/views/shiny_thing/admin/menu/_other_item.html.erb` will be rendered as an item in the Other section of the admin area menu
* `ShinyThing/app/views/shiny_thing/admin/toolbar/_section.html.erb` will be rendered in the admin toolbar

Helpers:
* Methods in `ShinyThing/app/helper/shiny_thing/MainSiteHelper.rb` will be available to all main site views, not just those rendered by your plugin's controllers


### Share and Enjoy!

If possible, please share your plugin with other ShinyCMS users by making a PR back to the main ShinyCMS-ruby repo on GitHub :)
