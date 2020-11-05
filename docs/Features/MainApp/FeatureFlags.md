# ShinyCMS Features

## Feature Flags

Quickly and easily enable or disable CMS features (e.g. 'new user registrations') in the admin area.


### Rake task

Feature flags can be checked and controlled on the command line too, via a rake task:
```
rails shiny:features:list
rails shiny:feature:off[user_registrations]
```


#### Plugin status

This feature would be the very last one to be converted into a plugin - after [User Accounts](UserAccounts.md) and [Site Settings](SiteSettings.md).
