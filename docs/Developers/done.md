# ShinyCMS: Project Progress

## Done

### Features from the Perl version that are now available in the Ruby version

(Noting improvements from the Perl version, if any)

* Pages, with page templates, page sections, and dynamically-generated menus
  * Improvements: the Perl version required all pages to be in a section, and
    you could only nest sections two levels deep. The Ruby version allows you
    to have pages at the top-level of your site, and to nest sections to any
    depth.
* Inserts (re-usable content fragments that can be pulled into any template)
  * Improvements: snappier name? ;) (Renamed from Shared Content to Inserts)
* Blog
* News section
* Nested comment threads
  * Currently enabled on blog posts and news posts
  * Ready to add to any other content type going forward
  * Improvements: Perl's main ORM doesn't have native support for polymorphism,
    and in fact I'd never heard of polymorphism at the time - but to get the
    comments feature to work how I wanted, I basically came up with all the
    same ideas. The Ruby version uses ActiveRecord's native polymorphism,
    which is no doubt better than my hand-rolled version :)
* Tags
  * Currently enabled on blog posts and news posts
  * Ready to add to any other content type going forward
  * Improvements: more generic implementation (powered by ActAsTaggableOn)
* 'Likes'
  * Currently enabled on comments, blog posts, and news posts
  * Ready to add to any other content type going forward
  * Improvements: adds optional 'downvote' feature; more generic implementation
    (powered by ActsAsVoteable)
* User accounts and administration
  * Improvements: the Perl version has role-based authorisation. The Ruby
    version has more flexible ACL-based authorisation (powered by Pundit).
* reCAPTCHA bot protection for registration and comment forms
  * Improvements: supports reCAPTCHA v3 with scores. Tries an invisible
    CAPTCHA first, falling back to an interactive CAPTCHA if that fails.
* Akismet support, to flag potential spam comments
  * Moderation queue in admin area
  * Confirming/removing flag sends ham/spam training data to Akismet
  * Improvements: the Perl version doesn't feed back to Akismet (yet)

### Features that the Perl version didn't have, but the Ruby version does

* Support for themes
  * Override the core templates on a per-file, as-needed basis
  * One theme included
* Built-in email stats
  * Track opens and/or link-clicks
  * Disabled in default settings (privacy, yay!)
  * Powered by Ahoy::Email
* Built-in web stats
  * Track visits, visitors, page views, etc
  * Support for GDPR-friendly stats (IP masking, etc)
  * Disabled in default settings
  * Powered by Ahoy


## TODO / In Progress

See the [TODO](TODO.md) list for features from the original ShinyCMS that I haven't started implementing
in this version yet... as well as ideas for new features, that I'm trying to resist building until I've
caught up with the Perl feature list.

See the [in-progress](in-progress.md) list for features that I am currently working on
(with notes on where I'm up to, and links to useful docs).
