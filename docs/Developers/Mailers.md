# ShinyCMS Development Documentation

## Fitting into ShinyCMS

If you inherit from ShinyCMS::Mailer then you'll need to implement a couple of (simple) methods used by before/after actions, that will mean:
a) Your mailer is included in the site-wide feature flag for all email-sending features (useful in case of runaway spam emergency or whatever)
b) Your mailer will honour the DoNotContact list (very important!)
c) Your site will check and honour double opt-in (also important!)


## Working on Mailers

Mailers have special config in dev and test environments, because sending test content to your real mailing list is embarrassing at best, and quite probably against the law too.


### Dev site 'Outbox'

If you're working on a new mailer or anything that sends email, you'll probably find http://localhost:3000/dev/outbox useful - any email sent by your dev site will end up captured there instead of actually being sent. It's all presented via a webmail-ish interface, so you can check the content easily.

This feature is powered by the [letter_opener_web](https://github.com/fgrehm/letter_opener_web#readme) gem.


### Test suite mailer config

The test environment includes the following two lines, which run your .deliver_later mailer jobs now not later, and put your test suite emails somewhere testable (ActionMailer::Base.deliveries):

  config.active_job.queue_adapter = :test
  config.action_mailer.delivery_method = :test

You can look at the tests in the ShinyNewsletters plugin for examples of how to test email jobs are queued and processed correctly.
