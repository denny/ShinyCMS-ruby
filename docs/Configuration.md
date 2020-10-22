# ShinyCMS Documentation

## Configuration

Configuration is split between the following locations:

### ENV vars

* Mostly used for secrets (database details, API keys etc)
* Usually loaded from .env* files, or from Settings > Config Vars on Heroku
* See docs/env.sample for a full list of available ENV settings

### Feature Flags

* Turn CMS features on (or off) for all users, logged-in only, or admin only
* Controlled in the CMS admin area - /admin/feature-flags
* Can also be turned on or off, and listed, from the command line:
```
rails shiny:features:list
rails shiny:feature:off[user_logins]
```

### Site Settings

* Configuration of CMS options and features
* Controlled in the CMS admin area - /admin/site-settings


## Services

The external services listed below are optional. If you add config details for them (via a .env* file (see [env.sample](env.sample)), or via your Config Vars on Heroku) then the related CMS features will be enabled or enhanced, otherwise those features will be unavailable or will have more limited functionality.

### AWS S3 - file storage

User uploaded files can be stored on AWS S3 instead of locally. To enable this feature you will need to have an an AWS account, create an S3 bucket, and add the relevant keys to the ENV/config.

### reCAPTCHA - bot protection

User registration and posting comments can be protected from bots using Google's reCAPTCHA service. To enable this feature you will need to obtain keys and add them to your ENV/config. You will get the best results with a pair of V3 keys and a pair of V2 keys (this allows you to set a minimum score for each protected feature in your Site Settings area). At first reCAPTCHA tries an 'invisible' (non-interactive) check (V3 with score if configured, V2 otherwise), falling back to a V2 checkbox if that fails.

### Akismet - spam flagging

Comments can be passed to Akismet for its assessment of whether they are likely to be spam or not. Comments flagged as spam will be hidden on the main site and shown in an admin moderation queue.

Processing comments in the moderation queue will send training data back to Akismet, which they use to improve their accuracy over time.


## Other services used (no config required)

### Have I Been Pwned - password leak checking

The user registration and login features use Devise::PwnedPassword to check user's passwords against https://haveibeenpwned.com/Passwords and warn the user if they find a match, but this doesn't require any setup on your part.
