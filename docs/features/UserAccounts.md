# ShinyCMS Features

## User accounts

User accounts handle authentication, registration, etc. They are powered by Devise.

https://github.com/heartcombo/devise#readme

Almost all of Devise's standard features are enabled by default, with the exception of Omniauth.

### User profile pages

Profile pages are handled by the [ShinyProfiles](../plugins/ShinyProfiles.md) plugin, not by the core user account code, but separating these two areas of functionality is currently a work in progress. The controllers and view templates are separate, but the models and database tables have not been split up yet.
