# ShinyCMS Documentation

## Rake tasks

ShinyCMS and its plugins include a number of rake tasks.

The bulk of these are the 'install migrations' and 'load db seeds' tasks for each plugin; in the case that a plugin lacks one or both of these tasks, it will be because the nature of the plugin means that it doesn't store data in the database (e.g. ShinySearch) and/or it doesn't have any settings or feature flags (so far I don't think this is actually true of any plugin).

Aside from those db loading tasks, here's what's left:
```
rails shiny:admin:create                # create a new super-admin user (all capabilities enabled)
rails shiny:demo:load                   # reset database, create admin user, and load demo site data
rails shiny:demo:dump                   # dump current database content into db/demo_data.rb
rails shiny:feature:off[name]           # toggle a feature flag off
rails shiny:feature:on[name]            # toggle a feature flag on
rails shiny:features:list               # list feature flags and status
rails shiny_newsletters:scheduled:send  # check for and start any scheduled sends that are due
```
