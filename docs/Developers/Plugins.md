# ShinyCMS Developer Documentation

## Writing Plugins

1. Move into the base directory of your copy of the ShinyCMS code
`cd ShinyCMS`

2. Run the plugin generator!
`rails g shiny:plugin plugins/ShinyThings`

This is a cut-down version of the standard Rails Engine generator (rails new plugin --mountable) with some added boilerplate to fit into ShinyCMS. Currently your plugin must be named Shiny{Something} for all the file path bodges to work; a better system will hopefully replace this at some point. But not today. :)

Optionally, you can add various skip flags which the rails plugin generator knows about, if you know you won't need those Rails features; e.g:
`rails g shiny:plugin --skip-action-mailer --skip-action-mailbox --skip-action-cable plugins/ShinyThings`

3. Change directory into your shiny (see what I did there?) new plugin!
`cd plugins/ShinyThings`

4. You will probably want to edit some of the details in these files:
- shiny_things.gemspec
- README.md

5. You will probably want to put code into some of the files under app/ and config/ :)

6. You can put tests in spec/ and run them from the ShinyCMS root directory:
`rspec plugins/ShinyThings/spec`

7. "Share and enjoy!"
