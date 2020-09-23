# ShinyCMS: Project Progress

## In progress

Features from the Perl version that I'm halfway through re-implementing in the Ruby version
(with notes on where I'm up to, what I'm stuck on, links to useful docs, etc)

* Newsletters (HTML mailshots) and mailing lists
  * Nearly done!
  * Add a nice default template or two, from https://mjml.io/templates/newsletter-email
  * Do some end-to-end testing, i.e. 'try to use it'

* User profile pages (with content such as recent comments, recent posts, etc)

### New features that snuck in ahead of schedule

* Plugin architecture
  * I'm in the process of converting all the initial features into Rails Engine plugins

* Blazer dashboards / charts / etc
  * https://github.com/ankane/blazer
  * This is merged, but needs a default dashboard and queries setting up

* Algolia search backend
	* https://devcenter.heroku.com/articles/algoliasearch#using-with-rails
  * NB: Not free to non-commercial sites using the CMS :(

* Multiple blog support
  * The original version had some unfinished code around this, which initially got ported straight across, but has now been split off into an unfinished ShinyBlogs plugin while the ShinyBlog plugin has a cleaner single-blog implementation


## Done / TODO

See the [done](done.md) list for features from the original ShinyCMS that I have already implemented
in this version - as well as a few new ones that snuck in along the way - with notes on improvements
from the Perl version where applicable.

See the [TODO](TODO.md) list for features from the original ShinyCMS that I haven't started implementing
in this version yet... as well as ideas for new features, that I'm trying to resist building until I've
caught up with the Perl feature list.
