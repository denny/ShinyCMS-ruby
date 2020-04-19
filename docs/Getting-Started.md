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

The default theme can be set in ENV['SHINYCMS_THEME'] and on the Site Settings
page in the admin area. If both are set, the latter takes priority. You can also
choose to make this setting user-overridable, in which case a user's setting
will take priority for them.


## Demo site

There is a set of demo data available, which will allow you to try out most
ShinyCMS features without having to create your own test data first. You can
load it with the utility script `tools/insert-demo-site-data`

WARNING: DATA LOSS! This script will wipe most of the tables in the database
before populating them with the demo site data; notably, this includes the
`users` table. Back up any data that you don't want to lose!

The demo data creates a super-admin user with the login details:
Username: admin
Password: I should change this password before I do anything else!

NB: The demo data (a) enables the user_login feature of the site, (b) sets a
non-secret username and password, and (c) loads the demo page content, which
will easily identify your site as being based on the demo data. PLEASE change
the password before you do anything else - and ideally the username too, if
you're leaving the demo data loaded for any length of time.

You can also easily disable the login feature again when you're not actively
using the site, with the rake command `rails shiny:feature:off[user_login]`
