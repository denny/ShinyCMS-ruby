# ShinyCMS Documentation

## Rake tasks

ShinyCMS and its plugins include a number of rake tasks, in addition to those provided by Rails.

You can use the command `rails --tasks` to see all the available tasks, or `rails --tasks | grep shiny` to show just the ShinyCMS tasks.


### Create new admin user

```
rails shinycms:admin:create    # ShinyCMS: create a new super-admin user
```

Prompts you for username, email, and password, and then uses those details to create a new CMS user with all admin capabilities enabled.


### Feature Flags

```
rails shinycms:features:list        # ShinyCMS: list feature flags and status
rails shinycms:feature:on[name]     # ShinyCMS: toggle a feature flag on
rails shinycms:feature:off[name]    # ShinyCMS: toggle a feature flag off
```

These tasks can be used to enable and disable CMS features from the command line. This may be useful if you are unable to reach the CMS admin area on your website for some reason - for example, if you turn off the user logins feature, thereby logging yourself out along with everybody else.


### ShinyNewsletters: start scheduled sends

```
rails shiny_newsletters:scheduled:send    # ShinyCMS: check for and start any scheduled sends that are due
```

This task can be scheduled to run as a regular task, or run on an ad-hoc basis, or both.


### Delete unwanted session data

```
rails shinycms:sessions:clean    # ShinyCMS: delete data for short sessions
```

This task deletes session data for any sessions that lasted less than the specified number of seconds (e.g. `rails shinycms:sessions:clean 3` will remove sessions that lasted less than 3 seconds in total) - not including sessions from the current date.

```
rails db:sessions:trim    # Trim old sessions from the table (default: > 30 days)
```

Rails provides this task to remove older sessions (over 30 days old by default, or you can set SESSION_DAYS_TRIM_THRESHOLD for a different limit). You may wish to schedule this to run every night to prevent the sessions table in your database from growing too large.


### Sitemaps

```
rails sitemap:create     # Generate sitemaps but don't ping search engines
rails sitemap:refresh    # Generate sitemaps and ping search engines
```

These tasks are provided by the [sitemap_generator](https://github.com/kjvarga/sitemap_generator#readme) gem. They use the configuration file at `config/sitemap.rb`, and write the generated sitemap file to `public/sitemap.xml.gz` (or to AWS S3, if you have that configured).


### Demo site data

```
rails shinycms:demo:load    # ShinyCMS: reset database, create admin user, and load demo site data
```

This task allows you to load the data for the demo site, so you can experiment with all of the CMS features. Be aware that this task will wipe the current contents of the database before it loads the demo site data - before you run it, back up anything that you want to keep!


### Plugin migrations and seed data

```
rails shiny_[various]:db:seed               # ShinyCMS: load supporting data for Shiny**** plugin
rails shiny_[various]:install:migrations    # Copy migrations from shiny_**** to application
```

The rest of the rake tasks added by ShinyCMS are the tasks to install migrations and load seed data for each plugin.

Currently, running the main `rails db:seed` task also runs all of the plugin seed tasks, so you should not need to run these tasks separately.

Similarly, the plugin tables are already included in the main `db/schema.rb` used to create the database - so you shouldn't need to run the install migration tasks, or the resulting migrations, as part of the standard install process.

In the case that a plugin does not provide a migration install task, it will be because that plugin doesn't store any data in the database (e.g. ShinySearch). All plugins currently provide a seed task (to add settings and feature flags, if nothing else).
