# ShinyCMS: Project Progress

## In progress

Features that I'm halfway through implementing (with notes on where I'm up to, what I'm stuck on, links to useful docs, etc)

### Features that exist in the Perl version

* Newsletters (HTML mailshots) and mailing lists
  * Nearly done!
  * Add a nice default template or two, from https://mjml.io/templates/newsletter-email
  * Do some end-to-end testing, i.e. 'try to use it'

* User profile pages (with content such as recent comments, recent posts, etc)

### Features that don't exist in the Perl version but I seem to be working on them anyway

* Plugin architecture
  * I've converted most of the existing features into Rails Engine plugins
  * Still to do:
    * Move Comments, Tags, and Likes into plugins
    * Move concerns and helpers into a plugin (ShinyToolbox?)
      * Eventually, break them up into multiple plugins (ShinyPostTools, ShinyTemplateTools, etc)
    * Look into moving Users into a plugin
      * Ideally, move all the non-Devise User/Account functionality into concerns and helpers, so
        you could include those into any site with Devise-powered auth and then use any ShinyPlugin
    * Move each plugin into its own separate gem
      * Move pages, newsletters, and forms test templates into each plugin's spec/fixtures

* Blazer dashboards / charts / etc
  * https://github.com/ankane/blazer
  * This is merged, but needs a default dashboard and queries setting up

* Algolia search backend
	* https://devcenter.heroku.com/articles/algoliasearch#using-with-rails
  * NB: Not free to non-commercial sites using the CMS :(

* Multiple blog support
  * The Perl version had some unfinished code for having multiple blogs on a single 'journal style' site
  * When I reimplemented the Blog feature I split it into two plugins:
    * ShinyBlog (single blog, finished (for now) and merged)
    * ShinyBlogs (multi-blog, not finished, still in a branch)


## Done / TODO

See the [done](done.md) list for features from the original ShinyCMS that I have already implemented
in this version - as well as a few new ones that snuck in along the way - with notes on improvements
from the Perl version where applicable.

See the [TODO](TODO.md) list for features from the original ShinyCMS that I haven't started implementing
in this version yet... as well as ideas for new features, that I'm trying to resist building until I've
caught up with the Perl feature list.
