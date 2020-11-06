# ShinyCMS Developer Documentation

## Demo site data

The demo site data can be dumped and loaded using the rake tasks:

`rails shiny:demo:dump` - this will dump the current contents of the database into `db/demo_data.rb` (only from models that include ShinyDemoDataProvider)

`rails shiny:demo:load` - and reply 'Y' to the 'Are you sure?' question - this will wipe your database!
