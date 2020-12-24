# ShinyCMS Developer Documentation

## Demo site data

The demo site data can be loaded and updated using the `rails shiny:demo:*` rake tasks:

### To load the existing demo data

Run `rails shiny:demo:load` (and reply 'Y' to the 'Are you sure?' question) - this will first run `rails db:reset` (losing any data that you have already entered) and then load in the demo site data. It will also prompt you for login details for a new super-admin account and create that for you.

### To create a new version of the demo data

Run `rails shiny:demo:dump` - this will dump the current contents of the database into `db/demo_data.rb` (only from models that include ShinyDemoDataProvider)
