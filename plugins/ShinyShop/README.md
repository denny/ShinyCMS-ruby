# ShinyShop: Ecommerce plugin for ShinyCMS

ShinyShop is a plugin for [ShinyCMS](https://shinycms.org) which adds shop features to your ShinyCMS website.


## Installation

Add 'ShinyShop' to the SHINYCMS_PLUGINS ENV var, then run `bundle install` for your main ShinyCMS app.

To add the ShinyShop tables and supporting data to your ShinyCMS database:
```bash
rails shiny_shop:install:migrations
rails db:migrate
rails shiny_shop:db:seed
```


## Contributing

See the ShinyCMS developer documentation for information on contributing to this plugin or any other part of the ShinyCMS project.

Please read the Code of Conduct as well.


## Copyright and Licensing

ShinyCMS is copyright 2009-2026 Denny de la Haye https://denny.me

This ShinyCMS plugin is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later). You should have copies of both v2 and v3 of the GPL in your ShinyCMS docs folder, or you can read them online: https://opensource.org/licenses/gpl-2.0 / https://opensource.org/licenses/gpl-3.0
