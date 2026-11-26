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
`rails shinycms:demo:load`

If you didn't load the demo data, create an admin account:  
`rails shinycms:admin:create`

Start the server:  
`rails s`

You should now have a ShinyCMS site at http://localhost:3000, with an admin area at http://localhost:3000/admin

### Installation for contributors

Create a fork of the project (middle button that says "Fork" near starred and watch button. Above the Green Code button on the main page of the repository)

Get the code (replace username with your github username)
```
git clone https://github.com/username/ShinyCMS-ruby.git
cd ShinyCMS-ruby
```

Copy the example config file and edit it to suit your requirements (in particular, you might need to set your DATABASE_URL):
`cp docs/env.sample .env.development.local`

Note: Generally you would need to replace the "your_db_password" with the password for your postgresql database that was named after your computer username and create populate the field "SECRET_KEY_BASE" with the value from rails secret, but you can only do this after bundle install command is issued on the terminal.

Install the required Ruby and JavaScript libraries:
```
bundle install
yarn install
```

Create database:
`rails db:setup`

If you want to load the [demo data](demo-site.md):

If you didn't load the demo data, create an admin account:
`rails shinycms:admin:create`

Start the server:
`rails s`

You should now have a ShinyCMS site at http://localhost:3000, with an admin area at http://localhost:3000/admin.

In order to make changes, create a branch using git
`git branch name-of-branch`

Change to this branch
`git checkout name-of-branch`

Make your changes on this branch

Push your changes to Github
`git push origin name-of-branch`

Go to github and submit a pull request (In the project repository will appear a prompt to submit a pull request, add a title and the associated issue, give a description and what problem it solves and submit)

Wait for the approval of your changes

Perhaps in a nearby future your changes might be accepted and you might have change this project forever, thanks :)

P.S: Install the Github CLI and authenticate `gh auth login` to push changes using HTTP in your computer.

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

### Background tasks

You may wish to schedule one or more [rake tasks](rake-tasks.md) to run on a regular basis (e.g. hourly/daily), depending on your requirements.


## Themes

To build a site on top of ShinyCMS, you should start by [creating a theme](Themes.md) for it. This keeps your site layout and design tweaks separate from the default CMS templates, making future updates to the CMS easier to manage.
