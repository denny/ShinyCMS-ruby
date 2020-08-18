# ShinyCMS: Project Progress

## In progress

Features from the Perl version that I'm halfway through re-implementing in the Ruby version
(with notes on where I'm up to, what I'm stuck on, links to useful docs, etc)

* Newsletters (HTML mailshots)
  * MJML templates - https://mjml.io/documentation
  * Mailing lists
    * Getting a bit bogged down in feature creep on this one, need to make myself just MVP it!

### New features that snuck in ahead of schedule

* Blazer dashboards / charts / etc
  * https://github.com/ankane/blazer
  * This is merged, but needs a default dashboard and queries setting up

* Algolia search backend
	* https://devcenter.heroku.com/articles/algoliasearch#using-with-rails
  * NB: Not free to non-commercial sites using the CMS :(


## Done / TODO

See the [done](done.md) list for features from the original ShinyCMS that I have already implemented
in this version - as well as a few new ones that snuck in along the way - with notes on improvements
from the Perl version where applicable.

See the [TODO](TODO.md) list for features from the original ShinyCMS that I haven't started implementing
in this version yet... as well as ideas for new features, that I'm trying to resist building until I've
caught up with the Perl feature list.
