# ShinyCMS Developer Documentation

## Writing a new plugin

1. Move into the base directory of your copy of the ShinyCMS code:
`cd ShinyCMS`

2. Run the plugin generator:
`rails g shiny:plugin plugins/ShinyThing`

(Currently your plugin must be named Shiny{Something} for some filepath-dependent hacks to work.)

The plugin generator is a cut-down version of the standard Rails Engine generator (rails new plugin --mountable) with some added boilerplate to fit the resulting plugin into ShinyCMS. You can pass it flags which the rails plugin generator understands, to skip features that your plugin doesn't need - e.g:
`rails g shiny:plugin --skip-action-mailer --skip-action-mailbox --skip-action-cable plugins/ShinyThing`

3. You should put the appropriate details in `plugins/ShinyThing/shiny_thing.gemspec`, and you'll probably want to edit `plugins/ShinyThing/README.md` as well.

4. Most of your code probably goes in `plugins/ShinyThing/app/`, with routes and locale files in `plugins/ShinyThing/config/`

5. Your tests go in `plugins/ShinyThing/spec/` and you can run them from the ShinyCMS root directory:
```
rspec plugins/ShinyThing  # to run tests for just your new plugin
rspec spec plugins  # to run tests for the main app and all plugins
```

6. "Share and enjoy!"
