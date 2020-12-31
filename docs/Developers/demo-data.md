# ShinyCMS Developer Documentation

## Demo site data

The demo site data can be loaded and updated using the `rails shiny:demo:*` rake tasks:

### To load the existing demo data

Run `rails shiny:demo:load` (and reply 'Y' to the 'Are you sure?' question) - this will first run `rails db:reset` (losing any data that is currently in the database!) and then it will load in the demo site data. Finally, it will prompt you to enter login details for a new super-admin account, and it will create that for you.

If you're reloading the demo data frequently for some reason, you may wish to set some or all of the following ENV vars to save you from having to type the details in each time the admin account is recreated: SHINYCMS_ADMIN_USERNAME, SHINYCMS_ADMIN_EMAIL, SHINYCMS_ADMIN_PASSWORD.

Using these ENV vars has obvious security implications - particularly the last one! Please do not use them in a production environment, or on a shared server, or anywhere else that it might be a bad idea to publicly share the login details for your CMS admin account.

### To create a new version of the demo data

Run `rails shiny:demo:dump` - this will dump the current contents of the database into `db/demo_data.rb` (for each model that includes the ShinyDemoDataProvider concern)
