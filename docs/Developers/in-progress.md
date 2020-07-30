# ShinyCMS: Project Progress

## In progress

Features from the Perl version that I'm halfway through re-implementing in the Ruby version
(with notes on where I'm up to, what I'm stuck on, links to useful docs, etc)

* Form handlers (form->email, for contact pages and similar)
  * Implementing as a plugin, oooooh
    * If this goes well, then I have to refactor everything I've already done
      as plugins too. D'oh.
  * Structure more like pages in this version...
    * elements -> form fields
    * element type -> input type
    * template -> form layout
  * Is it time to write that ShinyStuff / ShinyThing / ShinyBit abstraction??
    * Trying for a 'halfway house' abstraction using concerns, for now.
  * Need a plugin installer task (to move migrations into place, and ... ?)

* Newsletters (HTML mailshots)
  * MJML templates - https://mjml.io/documentation
  * Mailing lists
    * Getting a bit bogged down in feature creep on this one, need to make myself just MVP it!

* Search feature
	* pg_search: https://github.com/Casecommons/pg_search/blob/master/README.md
    * Ties me to Postgres :-\
	* algolia: https://devcenter.heroku.com/articles/algoliasearch#using-with-rails
    * NB: Not free to non-commercial sites using the CMS :(

### New features that snuck in ahead of schedule

* Dashboards / charts / better views of stats
  * Blazer - https://github.com/ankane/blazer
  * I think this might actually be working now; need to build and test a sample dashboard!


## Done / TODO

See the [done](done.md) list for features from the original ShinyCMS that I have already implemented
in this version - as well as a few new ones that snuck in along the way - with notes on improvements
from the Perl version where applicable.

See the [TODO](TODO.md) list for features from the original ShinyCMS that I haven't started implementing
in this version yet... as well as ideas for new features, that I'm trying to resist building until I've
caught up with the Perl feature list.
