# ShinyCMS Developer Documentation

## Model concerns

There are a number of model concerns provided with ShinyCMS. As well as DRYing up common features, I hope these will make it easier for other developers to build new features that [work similarly][Why does this matter?] to the existing features (from both a user and developer perspective).


### In the core plugin

* CanHide         - check or change visible/hidden status of content
* HasDemoData     - for models that may provide data for the demo site
* HasPublicName   - `.name` method - returns public_name if set, internal_name otherwise
* HasReadableName - get a human-readable (and optionally, localised) version of model's class name
* SoftDelete      - adds soft delete (from acts_as_paranoid gem)

* ShinyEmail      - sets/searches/validates canonical_email as well as email
* ShinyTeaser     - generate a truncated 'teaser' of a longer post
* ShinyToken      - generate/reset/check UUID token attributes, with optional expiry times

* HasSlug                - for models with a slug attribute (usually for URLs)
* HasSlugUniqueInMonth   - slug is only unique within a month (includes HasSlug)
* HasSlugUniqueInSection - slug is only unique within a section (includes HasSlug)

* ShinyPost       - common behaviour for 'posts' (e.g. ShinyBlog::Post, ShinyNews::Post) (includes CanHide, HasReadableName, HasSlugUniqueInMonth, SoftDelete, ShinyTeaser)

#### Concerns for templates and templated content

* Template        - common attributes and behaviour for any kind of layout template
* HTMLTemplate    - HTML-based layout templates (e.g. ShinyPages::Template) (includes Template)
* MJMLTemplate    - MJML-based layout templates (e.g. ShinyNewsletters::Template) (includes Template)

* HasTemplate     - content that has its layout defined by a template (e.g. ShinyPages::Page, ShinyNewsletters::Edition)

* Element         - common behaviour for elements of templates and templated content
* TemplateElement - elements of a layout template (e.g. ShinyPages::TemplateElement, ShinyNewsletters::TemplateElement) (includes Element)


### In feature plugins

* ShinySearch::Searchable - for models that want to be discoverable by the search feature


##### Links

[Why does this matter?]: https://en.wikipedia.org/wiki/Principle_of_least_astonishment 'Principle of Least Surprise'
