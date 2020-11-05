# ShinyCMS Documentation

## Demo site

### Theme / templates

The demo site uses the Halcyonic theme, whose templates are currently included with a standard install of the CMS. This may change in future, but for now you will already have the demo site theme templates in place.

### Demo data

There is a set of demo data available, which adds a small amount of content for each of the CMS features. This allows you to try out most of these features without having to invent and input your own test data first.

NB: Loading the demo data will wipe the current contents of the database. Before you run this rake task, back up any data that you don't want to lose.

To load the demo data: `rails shiny:demo:load` (and reply 'Y' to the 'Are you sure?' question)

### Heroku

You can run a test/demo install of ShinyCMS on Heroku for free, using free dynos for web and worker, and 'Hobby Dev' add-ons for Postgres and Redis. A suitable Procfile is provided.

#### Loading the demo site data on Heroku

To load the demo data into a Heroku Postgres add-on, first load it locally using the instructions above and in the [installation guide](INSTALL.md), then use the following commands to upload it to your Heroku Postgres add-on database (substituting your own app name and heroku pg instance name, obviously):
```
heroku pg:reset postgresql-something-99999 --app my-app-name --confirm my-app-name
heroku pg:push shinycms postgresql-something-99999 --app my-app-name
```
