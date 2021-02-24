# ShinyCMS Developer Documentation

## Concerns

There are a number of concerns provided with ShinyCMS. These are intended to make it easier for people to build new features that work similarly to the existing features, from both a user and developer perspective.

### In the core plugin

* CanHide                - check or change visible/hidden status of content on the site/in menus/etc
* HasName                - provides `.name` method (returns public_name if one is set, internal_name otherwise)
* ShinyClassName         - return a 'human friendly', translatable version of model's class name
* ShinyDemoDataProvider  - identifies models that may provide data to the demo site
* ShinyEmail             - sets/searches/validates models by canonical_email as well as email
* ShinySoftDelete        - enables soft delete features (from acts_as_paranoid) when included
* ShinyTeaser            - generate a truncated 'teaser' of a longer post, and related methods
* ShinyToken             - generate/reset/check UUID token attributes with optional expiry times

* HasSlug                - for models with a URL slug attribute
* HasSlugUniqueInMonth   - enforces slug uniqueness within each month   (includes HasSlug)
* HasSlugUniqueInSection - enforces slug uniqueness within each section (includes HasSlug)

* ShinyPost              - common behaviour for 'posts' (includes ShinyClassName, ShinyShowHide, ShinySlugInMonth, ShinySoftDelete, ShinyTeaser) (included by ShinyBlog::Post, ShinyNews::Post)

* WithTemplate           - for models that use a template for layout (included by ShinyPages::Page, ShinyNewsletters::Edition)
* ShinyElement           - for models that are elements of templates or templated content

* ShinyTemplate          - common attributes and behaviours for models that are any kind of layout template
* ShinyHTMLTemplate      - for HTML-based layout templates (includes ShinyTemplate) (included by ShinyPages::Template)
* ShinyMJMLTemplate      - for MJML-based layout templates (includes ShinyTemplate) (included by ShinyNewsletters::Template)
* ShinyTemplateElement   - for models that are elements of a layout template (includes ShinyElement) (included by ShinyPages::TemplateElement, ShinyNewsletters::TemplateElement)

### In feature plugins

* ShinySearch::Searchable - for models that want to be discoverable by the search feature
