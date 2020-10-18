# ShinyCMS Developer Documentation

## Concerns

There are a number of concerns provided with ShinyCMS. These are intended to make it easier for people to build new features that work similarly to the existing features, from both a user and developer perspective.

### In the main app

* ShinyClassName - lets models return a 'human friendly' version of their class name
* ShinyDemoDataProvider - identifies models that will provide data to the demo site
* ShinyEmail - for models with email attributes
* ShinyName - for models with an optional public_name and a compulsory internal_name
* ShinyShowHide - for things that can be visible or hidden on the site/menu/etc
* ShinyTeaser - for models that want to generate a short 'teaser' of a longer post
* ShinyToken - for models with UUID token attributes

* ShinySlug - for models with a URL slug attribute
* ShinySlugInMonth - enforces slug uniqueness within each month (includes ShinySlug)
* ShinySlugInSection - enforces slug uniqueness within each section (includes ShinySlug)

* ShinyPost - for models with a 'post' format (e.g. blog posts, news posts) (includes ShinyClassName, ShinyShowHide, ShinySlugInMonth, and ShinyTeaser)

* ShinyWithTemplate - for models that use a template for layout (e.g. pages, newsletter editions)
* ShinyElement - for models that are elements of templates or templated content

* ShinyTemplate - for all models that are a layout template (e.g. page templates, newsletter templates)
* ShinyHTMLTemplate - for models that are an HTML-based layout template (includes ShinyTemplate)
* ShinyMJMLTemplate - for models that are an MJML-based layout template (includes ShinyTemplate)
* ShinyTemplateElement - for models that are elements of a template (includes ShinyElement)

### In plugins

* ShinySearch::Searchable - for models that want to be discoverable by the search feature
