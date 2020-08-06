# ShinyNews: News section plugin for ShinyCMS

ShinyNews is a plugin for [ShinyCMS](https://shinycms.com) which adds a news
section to your ShinyCMS website.

News posts can be added and edited in the ShinyCMS admin area; look for 'News'
in your admin menu after enabling this plugin.


## Installation

Add 'ShinyNews' to the SHINYCMS_PLUGINS ENV var, then run `bundle install`
for your main ShinyCMS app.

(Currently, all plugins are enabled by default, so you don't need to
explicitly set the ENV var unless you want to load a subset of plugins.)

To add the ShinyNews tables and supporting data to your ShinyCMS database:
```bash
rails shiny_news:install:migrations
rails db:migrate
rails shiny_news:db:seed
```


## Contributing

See the developer documentation for information on ShinyCMS features
[in progress](docs/Developer/Progress.md) and [to-do](docs/Developer/TODO.md)

Please read the [Code of Conduct](docs/code-of-conduct.md) as well.


## License

This ShinyCMS plugin is free software; you can redistribute it and/or modify it
under the terms of the GPL (version 2 or later). You should have copies of both
v2 and v2 of the GPL in your ShinyCMS docs folder, or you can read them online:  
https://opensource.org/licenses/gpl-2.0  
https://opensource.org/licenses/gpl-3.0
