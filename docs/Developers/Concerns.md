# ShinyCMS Developer Documentation

## Concerns

There are a number of concerns provided with ShinyCMS. These are intended to make it easier for people to build new features that work similarly to the existing features, from both a user and developer perspective.

### In the core plugin

* CanHide                - check or change visible/hidden status of content on the site/in menus/etc
* HasName                - provides `.name` method (returns public_name if one is set, internal_name otherwise)
* SoftDelete             - adds soft delete (from acts_as_paranoid gem)

* ShinyClassName         - return a 'human friendly', translatable version of model's class name
* ShinyDemoDataProvider  - identifies models that may provide data to the demo site
* ShinyEmail             - sets/searches/validates models by canonical_email as well as email
* ShinyTeaser            - generate a truncated 'teaser' of a longer post, and related methods
* ShinyToken             - generate/reset/check UUID token attributes with optional expiry times

* HasSlug                - for models with a URL slug attribute
* HasSlugUniqueInMonth   - enforces slug uniqueness within each month   (includes HasSlug)
* HasSlugUniqueInSection - enforces slug uniqueness within each section (includes HasSlug)

* ShinyPost              - common behaviour for 'posts' (includes ShinyClassName, CanHide, HasSlugUniqueInMonth, SoftDelete, ShinyTeaser) (included by ShinyBlog::Post, ShinyNews::Post)

* ShinyTemplate          - common attributes and behaviour for models that are any kind of layout template
* ShinyHTMLTemplate      - for HTML-based layout templates (includes ShinyTemplate) (e.g. ShinyPages::Template)
* ShinyMJMLTemplate      - for MJML-based layout templates (includes ShinyTemplate) (e.g. ShinyNewsletters::Template)

* ShinyElement           - for models that are elements of templates or templated content
* ShinyTemplateElement   - for models that are elements of a layout template (includes ShinyElement) (e.g. ShinyPages::TemplateElement, ShinyNewsletters::TemplateElement)

* WithTemplate           - for models that use a template for layout (e.g. ShinyPages::Page, ShinyNewsletters::Edition)

### In feature plugins

* ShinySearch::Searchable - for models that want to be discoverable by the search feature
