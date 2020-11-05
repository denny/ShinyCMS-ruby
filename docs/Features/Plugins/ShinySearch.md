# ShinyCMS Plugins

## ShinySearch

This plugin provides the search feature for the main site.

It has support for using a variety of backends to power the actual searching, but currently only the default search backend (pg_search) is implemented. This is powered by the [pg_search](https://github.com/Casecommons/pg_search#readme) gem.

There is some stub code showing where support for [Algolia](https://www.algolia.com/) (Search as a Service) could be added next, but no actual implementation.

### Integration with other features

Models in other plugins (and the main app) can provide a template for rendering themselves as a search result, which this plugin will look for and use if/when that model comes up in the results for a search.
