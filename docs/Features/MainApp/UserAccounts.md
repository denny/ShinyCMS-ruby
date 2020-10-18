# ShinyCMS Features

## User accounts

User accounts handle authentication, registration, etc. They are powered by [Devise](https://github.com/heartcombo/devise).

All of Devise's standard features are enabled by default, with the exception of Omniauth.

ShinyCMS extends Devise to allow site users to identity themselves with either a username or an email address during login (as standard, Devise will only accept an email address).

ShinyCMS also wraps Devise in its own [feature flags](FeatureFlags.md) code, allowing site admins with appropriate access to enable or disable the **user logins** and **user registration** features quickly and easily via either the CMS admin area on the website, or the feature flags [rake task](FeatureFlags.md#rake-task) on the command-line.


### Plugin status

User accounts may eventually be moved into a plugin (probably as a set of concerns and helpers that could be added to any site with Devise-powered authentication), but this isn't a high priority. The main app will remain necessary for some time just to handle user accounts, [site settings](SiteSettings.md), and [feature flags](FeatureFlags.md).


### Profile pages

User profile pages are handled by the [ShinyProfiles](../Plugins/ShinyProfiles.md) plugin, not by the user account code in the main app, but separating these two sets of features is still a work in progress (the controllers and view templates are separate now, but the models and database tables are not).
