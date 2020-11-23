# ShinyCMS Documentation

## Cloud hosting

### Webserver

#### Heroku

ShinyCMS has been tested with Heroku (currently, shinycms.org itself is hosted on Heroku).

With the provided Procfile and supporting utility scripts, deployment on Heroku should be straightforward.

### Database

#### AWS RDS / Heroku Postgres add-on

ShinyCMS has been tested with AWS RDS Postgres, and the Heroku Postgres add-on (which is just AWS RDS Postgres anyway).

There is some documentation to help with copying the demo site data into a Heroku add-on database.

### Sending email

If you enable any feature that sends email (user registrations, comment notifications, newsletters, etc), then you will need an email server or service. Anything supported by ActionMailer should work, but currently no cloud services have been tested, only standard SMTP.

### Cache

#### Heroku Redis

If you are using any feature that uses ActiveJob (including any feature that sends emails), you will need a caching backend for Sidekiq. Only the Heroku Redis add-on has been tested, but anything supported by ActionJob should work.

### File storage

#### AWS S3

User uploaded files can be stored on AWS S3 instead of locally.

To enable this feature you will need to have an AWS account, create an S3 bucket, and add the relevant keys to your ENV/config vars.

AWS S3 offers a limited amount of free usage, followed by fairly inexpensive usage-based pricing.
