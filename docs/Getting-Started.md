# Getting Started

## Deployment

You can deploy ShinyCMS to Heroku using the included Procfile, after setting
your config vars (see Configuration) and (optionally) adding a theme to
customise the appearance of your site.


## Configuration

You can configure your site via ENV vars in dev, or config vars on Heroku. See
.env.example for a list of the available config options.

You can also change some site settings in the admin area once ShinyCMS is
running.


## Themes

The recommended way to start building a site on ShinyCMS is to create a theme
for it. You can read more about creating themes in docs/themes.md

The default theme can be set in ENV['SHINYCMS_THEME'] and on the Settings page
in the admin area. If both are set, the latter takes priority. You can also
choose to make this setting user-overridable, in which case a user's setting
will take priority for them.


## Demo site

There is some demo data included, which will allow you to try out most ShinyCMS
features without having to create your own test data first. You can load it with
the utility script `tools/insert-demo-site-data`.

NB: This script will wipe most of the tables in the database before populating
them with the demo site data; notably, this includes the `users` table. Back up
any data that you don't want to lose!
