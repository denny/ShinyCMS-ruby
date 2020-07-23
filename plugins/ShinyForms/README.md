# ShinyCMS: ShinyForms plugin

This is a form handler plugin for [ShinyCMS](https://shinycms.com); it provides
a few different endpoints to which you can POST a suitably constructed HTML form,
and they will do Something Useful [tm] with it - e.g. email the form data to
whatever address you have configured, allowing you to quickly and easily add a
new contact form or an order enquiry form to your ShinyCMS-powered site).

Form handlers are created, configured, and controlled via the ShinyCMS admin area;
look for 'Form Handlers' in your admin menu after enabling this plugin.


## Installation

Add this line to your main ShinyCMS Gemfile (or uncomment it if it's already there):

```ruby
gem 'shiny_forms', path: 'plugins/ShinyForms'
```

Run `bundle install` to install the gem into your copy of ShinyCMS.

Next, run the rake task `rails shiny:forms:create_migration`, followed by
`rails db:migrate`, to add the ShinyForms tables to your ShinyCMS database.


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
