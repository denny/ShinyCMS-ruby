# ShinyCMS plugin

This plugin contains some core features of [ShinyCMS](https://shinycms.org), as well as the hooks to allow use of ShinyCMS feature plugins, and various common functionality those plugins can share.


## Installation

**Please see the [Installation Guide](../../docs/INSTALL.md) for more detailed instructions, with links to examples.**

You need to include some ShinyCMS code snippets in the `Gemfile` and `config/routes.rb` of the Rails application that you want to add ShinyCMS to. Then, add any ShinyCMS feature plugins that you want to use to the SHINYCMS_PLUGINS ENV var and run `plugins/ShinyCMS/tools/bundle-install` from the root of your host application.

It's not necessary to include this core plugin in the SHINYCMS_PLUGINS list, but it won't cause a problem if you do.

(Currently all plugins are enabled by default, so if you want to load all of the available plugins then you don't actually need to set the ENV var at all - but this behaviour may change in future.)

### Database setup

To add the ShinyCMS tables to your application's database:
```bash
rails shinycms:install:migrations
rails db:migrate
rails shinycms:db:seed
```

Once the tables are in place, load supporting data for the CMS and the core features:
```bash
rails shinycms:db:seed
```

## Contributing

See the ShinyCMS developer documentation for information on contributing to this plugin or any other part of the ShinyCMS project.

Please read the Code of Conduct as well.


## Copyright and Licensing

ShinyCMS is copyright 2009-2021 Denny de la Haye https://denny.me

ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later). You should have copies of both v2 and v2 of the GPL in the included docs folder, or you can read them online: https://opensource.org/licenses/gpl-2.0 / https://opensource.org/licenses/gpl-3.0
