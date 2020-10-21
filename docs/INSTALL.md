# ShinyCMS Documentation

## Installation (local dev system)

Get the code from GitHub:  
```
git clone https://github.com/denny/ShinyCMS-ruby.git
cd ShinyCMS-ruby
```

Copy the example config file and edit it to suit your requirements (in particular, you might need to set your DATABASE_URL):  
`cp docs/env.sample .env.development.local`

Install the required Ruby and JavaScript libraries:  
```
bundle install
yarn install
```

Create your database:  
`rails db:setup`

If you want to load the [demo data](demo-site.md):  
`rails shiny:demo:load`

If you didn't load the demo data, create an admin account:  
`rails shiny:admin:create`

Start the server:  
`rails s`

You should now have a ShinyCMS site at http://localhost:3000, with an admin area at http://localhost:3000/admin

### Job queues (for sending email)

If you want the system to send emails, you will need to run Sidekiq, which in turn requires you to run Redis:  
```
sudo service start redis  # or whatever your OS prefers
sidekiq
```

### Creating an admin account

When you load or reload the seed data (any of `rails db:setup`, `rails db:reset`, and `rails db:seed` will do this), the system checks that you have at least one 'super admin' user (an admin with the ability to add/remove admin users). If one does not already exist, you will be shown the command to create one: `rails shiny:admin:create`

When you run this command you will be prompted for a username, email address, and password for your new admin user, and then the account will be created with a full set of admin capabilities.

(The password will be checked against the PwnedPassword service, even for dev/demo sites, and simple or common passwords are very likely to fail this check. Use a good password to avoid frustration!)

If you are resetting your database or reloading the demo data a lot, you can save your chosen admin account details into your .env.development.local file and they will be picked up automatically during admin account creation, to save you typing them each time. **This has obvious security implications**, depending on who else might have (or gain) access to your filesystem.

### Blazer database user (for charts and dashboards)

If you intend to use Blazer to generate charts and dashboards, you will need to [create a read-only database user for Blazer](create-blazer-db-user.sql) (sample SQL) and add its details to your ENV/config as `BLAZER_DATABASE_URL`.


## Configuration

Configuration is split between ENV vars (usually in .env* files), Feature Flags, and Site Settings. See [configuration](Configuration.md) for more details of each.


## Themes

To build a site on top of ShinyCMS, you should start by [creating a theme](Themes.md) for it. This keeps your site layout and design tweaks separate from the default CMS templates, making future updates to the CMS easier to manage.
