# ShinyCMS Plugins

## ShinyNewsletters

This plugin adds the ability to send promotional HTML emails.

It requires ShinyLists to be enabled too, to manage mailing lists and subscriptions.

* Build HTML mailshots based on MJML templates (provided by a theme or custom built for you)
* Simple admin interface to fill in the editable content areas in each edition

### Scheduled sends

You can start any scheduled sends that are due by running the rake task `rails shiny_newsletters:scheduled:send`

On Heroku, you can use their Heroku Scheduler add-on to run this task daily, hourly, or every 10 minutes. The add-on itself is free, but you pay for the dyno time taken to run the task each time (unless you configure it to use the 'free' dyno type).

In other environments you could set this task to run regularly via cron or a similar tool.
