# ShinyCMS: Project Progress

## Done

### Features from the Perl version that are now available in the Ruby version

(Noting improvements from the Perl version, if any)

* Pages, with page templates, page sections, and dynamically-generated menus
    * Improvements: the Perl version requires all pages to be in a section, and
    you can only nest sections two levels deep. The Ruby version allows you to
    have pages at the top-level of your site, and to nest sections to any depth
* Inserts (re-usable content fragments that can be pulled into any template)
    * Improvements: snappier name? ;) (Renamed from Shared Content to Inserts)
* Access control for content on main site (separate from auth system for admin area)
* Basic form handlers
    * Improvements: MJML email templates
* Blog
    * Improvements: Split up single-blog and multi-blog versions (the latter of
    which was never fully implemented in the Perl version but just cluttered
    up the codebase a bit) into two separate plugins. Now the multi-blog
    feature is in an unmerged development branch and the merged single-blog
    code is much cleaner
* News section
* Newsletters and mailing lists
    * Improvements:
        * Email address verification (AKA double opt-in) for email recipients
        * MJML templates
        * Records exact consent text agreed to for list subscriptions (for GDPR compliance)
* Nested comment threads
    * Currently enabled on blog posts and news posts
    * Ready to add to any other content type going forward
    * Improvements:
        * Perl's main ORM doesn't have native support for polymorphism,
        and in fact I'd never heard of polymorphism at the time - but to get the
        comments feature to work how I wanted, I basically came up with all the
        same ideas. The Ruby version uses ActiveRecord's native polymorphism,
        which is no doubt better than my hand-rolled version :)
        * MJML templates for reply notification emails
        * Double opt-in required before sending notification emails
* Tags
    * Currently enabled on blog posts and news posts
    * Ready to add to any other content type going forward
    * Improvements: more generic implementation (powered by ActAsTaggableOn)
* 'Likes'
    * Currently enabled on comments, blog posts, and news posts
    * Ready to add to any other content type going forward
    * Improvements: adds optional 'downvote' feature; more generic implementation
    (powered by ActsAsVoteable)
* Site search
    * Improvements: Support for multiple search back-ends
* User accounts and administration
    * Improvements:
      * The Perl version has role-based authorisation. The Ruby version has
      more flexible ACL-based authorisation (powered by Pundit).
      * MJML templates for all user account emails (welcome, forgot password, etc)
* reCAPTCHA bot protection for registrations, comments, and forms
    * Improvements: supports reCAPTCHA v3 with scores. Tries an invisible
    CAPTCHA first, falling back to an interactive CAPTCHA if that fails.
* Akismet support, to flag potential spam comments and form submissions
    * Comment moderation queue in admin area
    * Confirming/removing flag sends ham/spam training data to Akismet
    * Improvements: the Perl version doesn't feed back to Akismet (yet)

### Features that the Perl version didn't have, but the Ruby version does

* Support for themes
    * Low-lift; override the core templates on a per-file, as-needed basis
    * Two themes included
* ShinyConcerns
    * While re-implementing various features I've tried to pull useful common
      functionality out into concerns, that might be handy building blocks for
      anybody else who wants to write a ShinyCMS plugin
* Recoverable soft delete on almost all models (powered by ActsAsParanoid)
* Admin page for viewing/managing (non-user) email recipients
* Email open and click tracking (powered by Ahoy::Email)
    * Disabled by default (privacy, yay!)
* Web tracking (powered by Ahoy) - track visits, visitors, page views, etc
    * Disabled by default, and has support for GDPR-friendly stats (IP masking, etc)
* Build your own charts and dashboards to dig into the data gathered by Ahoy (powered by Blazer)


## TODO / In Progress

See the [TODO](TODO.md) list for features from the original ShinyCMS that I haven't started implementing
in this version yet... as well as ideas for new features, that I'm trying to resist building until I've
caught up with the Perl feature list.

See the [in-progress](in-progress.md) list for features that I am currently working on
(with notes on where I'm up to, and links to useful docs).
