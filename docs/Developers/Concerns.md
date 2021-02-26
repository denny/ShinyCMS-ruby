# ShinyCMS Developer Documentation

## Model concerns

There are a number of model concerns provided with ShinyCMS. As well as DRYing up common features, I hope these will make it easier for other developers to build new features that [work similarly][Why does this matter?] to the existing features (from both a user and developer perspective).

### In the core plugin

* CanHide                - check or change visible/hidden status of content
* HasDemoData            - for models that may provide data for the demo site
* HasPublicName          - `.name` method - returns public_name if set, internal_name otherwise
* HasReadableName        - get a human-readable (and optionally, localised) version of model's class name
* SoftDelete             - adds soft delete (from acts_as_paranoid gem)

* ShinyEmail             - sets/searches/validates canonical_email as well as email
* ShinyTeaser            - generate a truncated 'teaser' of a longer post
* ShinyToken             - generate/reset/check UUID token attributes, with optional expiry times

* HasSlug                - for models with a slug attribute (usually for URLs)
* HasSlugUniqueInMonth   - slug is only unique within a month (includes HasSlug)
* HasSlugUniqueInSection - slug is only unique within a section (includes HasSlug)

* ShinyPost              - common behaviour for 'posts' (includes ShinyClassName, CanHide, HasSlugUniqueInMonth, SoftDelete, ShinyTeaser) (included by ShinyBlog::Post, ShinyNews::Post)

* ShinyTemplate          - common attributes and behaviour for models that are any kind of layout template
* ShinyHTMLTemplate      - for HTML-based layout templates (includes ShinyTemplate) (e.g. ShinyPages::Template)
* ShinyMJMLTemplate      - for MJML-based layout templates (includes ShinyTemplate) (e.g. ShinyNewsletters::Template)

* ShinyElement           - for models that are elements of templates or templated content
* ShinyTemplateElement   - for models that are elements of a layout template (includes ShinyElement) (e.g. ShinyPages::TemplateElement, ShinyNewsletters::TemplateElement)

* WithTemplate           - for models that use a template for layout (e.g. ShinyPages::Page, ShinyNewsletters::Edition)

### In feature plugins

* ShinySearch::Searchable - for models that want to be discoverable by the search feature


##### Links

[Why does this matter?]: https://en.wikipedia.org/wiki/Principle_of_least_astonishment 'Principle of Least Surprise'
