# ShinyForms: Form handlers plugin for ShinyCMS

ShinyForms is a plugin for [ShinyCMS](https://shinycms.org) which adds
some generic form handlers to your ShinyCMS site.

Form handlers are endpoints to which you can POST a suitably constructed
HTML form, and they will do Something Useful [tm] with it. The simplest
example emails the form data to the site owner - this allows you to quickly
and easily add a contact form or an order enquiry form to a ShinyCMS site.

Form handlers are created, configured, and controlled via the ShinyCMS admin
area; look for 'Form Handlers' in your admin menu after enabling this plugin.


## Installation

Add 'ShinyForms' to the SHINYCMS_PLUGINS ENV var, then run `bundle install`
for your main ShinyCMS app.

(Currently, all plugins are enabled by default, so you don't actually
need to set the ENV var unless you want to load a subset of plugins.)

To add the ShinyForms tables and supporting data to your ShinyCMS database:
```bash
rails shiny_forms:install:migrations
rails db:migrate
rails shiny_forms:db:seed
```


## Contributing

See the developer documentation for information on ShinyCMS features
[in progress](docs/Developer/Progress.md) and [to-do](docs/Developer/TODO.md)

Please read the [Code of Conduct](docs/code-of-conduct.md) as well.


## Copyright and Licensing

ShinyCMS is copyright 2009-2026 Denny de la Haye https://denny.me

ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later). You should have copies of both v2 and v2 of the GPL in the included docs folder, or you can read them online: https://opensource.org/licenses/gpl-2.0 / https://opensource.org/licenses/gpl-3.0
