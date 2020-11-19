# ShinyCMS Developer Documentation

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
            * Look at Combustion, for minimal test apps for gems: https://github.com/pat/combustion
            * List ShinyBlog on https://www.ruby-toolbox.com/categories/Blog_Engines

* Blazer charts (etc); feature is merged, but needs a default dashboard and queries setting up:
    * https://github.com/resool/blazer-demo/commit/bd24fbbbc0d8ba2de5b33cd3ec2c58713cffbc2b
    * https://github.com/resool/blazer-demo/commit/9d8ba40a223df6da668ca2b1786fdfc0b2fe0e76

* Algolia search backend: https://devcenter.heroku.com/articles/algoliasearch#using-with-rails
    * NB: Not free to non-commercial sites using the CMS :(
    * Breaking news from Bundler: A new major version is available for Algolia! Please now use the https://rubygems.org/gems/algolia gem to get the latest features.

* Multiple blog support
    * The Perl version had half-finished code for hosting multiple blogs on a single 'journal' site
    * In the Ruby version, this has been split into two plugins:
        * ShinyBlog (single blog) - finished (for now) and merged
        * ShinyBlogs (multi-blog) - not finished, still in a branch


## Done / TODO

See the [done](done.md) list for features from the original ShinyCMS that I have already implemented
in this version - as well as a few new ones that snuck in along the way - with notes on improvements
from the Perl version where applicable.

See the [TODO](TODO.md) list for features from the original ShinyCMS that I haven't started implementing
in this version yet... as well as ideas for new features, that I'm trying to resist building until I've
caught up with the Perl feature list.
