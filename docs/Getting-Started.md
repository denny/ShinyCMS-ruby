# ShinyCMS: Getting Started

## TL,DR

```bash
git clone https://github.com/denny/ShinyCMS-ruby.git
cd ShinyCMS-ruby
cp docs/env.sample .env.development.local
# Edit .env.development.local in case you want/need to change anything
bundle install
yarn install
rails db:setup
rails shiny:demo:load     # if you want the demo data loaded
rails shiny:admin:create  # if you didn't load the demo data
rails s
```

You should now have a ShinyCMS site at http://localhost:3000,
with an admin area at http://localhost:3000/admin


## The longer version

### Database

Set your DATABASE_URL (including username and password) in your .env.*.local files

To create the database: `rails db:create`  
To load the database schema: `rails db:schema:load`  
To load seed data: `rails db:seed`

To do all three in one command: `rails db:setup`


### Demo data

There is a set of demo data available, which will allow you to try out most
ShinyCMS features without having to create your own test data first.

WARNING: DATA LOSS!  
Loading the demo data will wipe the database - it's the first thing this rake
task does. Before you run it, back up any data that you don't want to lose!

To load the demo data: `rails shiny:demo:load`


### Deployment

There's a Procfile for easy deployment to Heroku. You can run a test/demo
install of ShinyCMS on there for free, using a Free Dyno for web and a
Postgres add-on at the Hobby Dev level.

To load the demo data on Heroku, first load it locally using the instructions
above, then use the following command to upload it to your Heroku Postgres
add-on database (NB: the first command wipes the Heroku database):  
`heroku pg:reset postgresql-whatever-99999 --app my-shinycms --confirm my-shinycms`  
`heroku pg:push shinycms postgresql-whatever-99999 --app my-shinycms`


### Configuration

Configuration is split between the following locations:

#### ENV vars

* Mostly used for secrets (database details, API keys etc)
* Usually loaded from .env* files, or from Settings > Config Vars on Heroku
* See docs/env.sample for a full list of possible ENV settings

#### Feature Flags

* Turn CMS features on (or off) for all users, logged-in only, or admin only
* Controlled in the CMS admin area - /admin/feature-flags
* Can also be turned on/off from the command line: `rails shiny:feature:on[tags]`

#### Site Settings

* Configuration of CMS options and features
* Controlled in the CMS admin area - /admin/site-settings


### Services

External services are mostly optional. If you add config settings for them
(via ENV vars on the command line, or via a .env file (see .env.example),
or via your Config Vars on Heroku) then they will be enabled, otherwise
either those features will be disabled or a fallback will take their place.

#### AWS S3 - file storage

User uploaded files can be stored on AWS S3 instead of locally. To enable this
feature you will need to have an an AWS account, create an S3 bucket, and add
the relevant keys to the ENV/config.

#### reCAPTCHA - bot protection

User registration and posting comments can be protected from bots using Google's
reCAPTCHA service. To enable this feature you will need to obtain keys and add
them to your ENV/config. You will get the best results with a pair of V3 keys
and a pair of V2 keys (this allows you to set a minimum score for each protected
feature in your Site Settings area). At first reCAPTCHA tries an 'invisible'
(non-interactive) check (V3 with score if configured, V2 otherwise), falling
back to a V2 checkbox if that fails.

#### Have I Been Pwned - password leak checking

The user registration and login features use Devise::PwnedPassword to check
user's passwords against https://haveibeenpwned.com/Passwords and warn the
user if they find a match, but this doesn't require any setup on your part.


### Themes

The recommended way to start building a site on ShinyCMS is to create a theme
for it. You can read more about creating themes in [docs/Themes](Themes.md)

The default theme can be set in ENV['SHINYCMS_THEME'] and on the Site Settings
page in the admin area. If both are set, the latter takes priority. You can also
choose to make this setting user-overridable, in which case a user's setting
will take priority for them.
