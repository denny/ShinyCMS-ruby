# ShinyCMS Documentation

## Required services

You will need a web server. As far as I am aware, any Rails-compatible web server should work.

You will need a database server. Currently this almost certainly needs to be Postgres-compatible (patches to be more database-agnostic welcome).

If you enable any feature that sends email (user registrations, comment notifications, newsletters, etc), then you will need an email server. Anything supported by ActionMailer should work.

For email, and possibly for other features, you will also need a job queue and a caching backend for it. Only Sidekiq + Redis have been tested, but anything compatible with ActionJob could potentially work.


## Optional services

The external services listed below are optional. If you add config details for them (via a .env* file locally (see [env.sample](env.sample)), or via Config Vars on Heroku) then the related CMS features will be enabled or enhanced. Otherwise those features will be unavailable or will have more limited functionality.

### AWS S3 - file storage

User uploaded files can be stored on AWS S3 instead of locally.

To enable this feature you will need to have an an AWS account, create an S3 bucket, and add the relevant keys to your ENV/config vars.

AWS S3 offers a limited amount of free usage, followed by fairly inexpensive usage-based pricing.

### reCAPTCHA - bot protection

User registration and posting comments can be protected from bots using Google's reCAPTCHA service.

To enable this feature you will need to obtain keys and add them to your ENV/config vars.

You will get the best results with a pair of V3 keys and a pair of V2 keys (this allows you to set a minimum score for each protected feature in your Site Settings area). At first reCAPTCHA tries an 'invisible' (non-interactive) check (V3 with score if configured, V2 otherwise), falling back to a V2 checkbox if that fails.

Google reCAPTCHA is free at any usage level.

### Akismet - spam flagging

Comments can be passed to Akismet for its assessment of whether they are likely to be spam or not. Comments flagged as spam will be hidden on the main site and shown in an admin moderation queue. Processing comments in the moderation queue will send training data back to Akismet, which they use to improve their accuracy over time.

To enable these features you will need to create an account at Akismet, and set the appropriate keys in your ENV/config vars.

Akismet offer a limited free service, and a variety of paid plans for busier sites.


## Other services

### Have I Been Pwned - password leak checking

The user registration, login, and change password features use [Devise::PwnedPassword](https://github.com/michaelbanfield/devise-pwned_password#readme) to check user's passwords against the [PwnedPasswords](https://haveibeenpwned.com/Passwords) service. If a match is found during registration or a password change then the user will have to choose a different password to complete the process. If a match is found during login, the user will be warned about the match.

You do not need to set up or configure anything to use this service in ShinyCMS - it is enabled by default - and it is free.
