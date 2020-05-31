# ShinyCMS: Project Progress

The original, [Perl version of ShinyCMS](https://github.com/denny/ShinyCMS) was
built to satisfy the varied requirements of a number of clients during 10 years
of working as a freelance web developer, so it's not a small project. Even
though I built the vast majority of it, I was still quite surprised at the
length of the feature list when I wrote it out at the start of this project.

Below are notes on my progress so far on reimplementing features from the Perl
version. Plus the occasional sneaky new feature that's crept in along the way :)


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
  * Currently on blog posts and news posts
  * Ready to add to any other content type going forward
  * Improvements: Perl's main ORM doesn't have native support for polymorphism,
      and in fact I'd never heard of polymorphism at the time - but to get the
      comments feature to work how I wanted, I basically came up with all the
      same ideas and ended up rolling my own version. The Ruby version uses
      ActiveRecord's native polymorphism, which seems to be a well-documented
      and hence presumably well-understood feature.
* Tags
  * Currently on blog posts and news posts
  * Ready to add to any other content type going forward
  * Improvements: more generic implementation (powered by ActAsTaggableOn)
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
* Built-in email stats
  * Track opens and/or link-clicks
  * Disabled in default settings (privacy, yay!)
  * Powered by Ahoy::Email
* Built-in web stats
  * Track visits, visitors, page views, etc
  * Support for GDPR-friendly stats (IP masking, etc)
  * Disabled in default settings
  * Powered by Ahoy


## In progress

Features from the Perl version that I'm currently re-implementing in the Ruby
version (with notes on useful docs, where I'm up to, what I'm stuck on, etc)

* Newsletters (HTML mailshots)
  * MJML templates - https://mjml.io/documentation
  * Mailing lists

* Dashboards / charts / better views of stats
  * Blazer ?
    * https://github.com/ankane/blazer
    * CSS conflicts rendering inside ShinyCMS admin area layout
      * Investigate Shadow DOM ?

* Search feature
	* pg_search: https://github.com/Casecommons/pg_search/blob/master/README.md
    * Ties me to Postgres :-\
	* algolia: https://devcenter.heroku.com/articles/algoliasearch#using-with-rails
    * NB: Not free to non-commercial sites using the CMS :(
  * Potentially useful Ruby feature: excerpt()
		* https://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html#method-i-excerpt


## To Do

See [the TODO list](TODO.md) for features from the original ShinyCMS that I
haven't started implementing in this version yet, as well as some new ideas.
