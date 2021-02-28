# ShinyCMS Developer Documentation

## Supporting code: model concerns

### In the core plugin

* CanHide         - check or change visible/hidden status of content
* HasEmail        - sets/searches/validates canonical_email as well as email
* HasPublicName   - `.name` method - returns public_name if set, internal_name otherwise
* HasReadableName - get a human-readable (and optionally, localised) version of model's class name
* HasTags         - pulls in ActsAsTaggableOn and adds helper methods to hide tags on hidden content
* HasTeaser       - generate a 'teaser' from first N paragraphs of a longer post
* HasToken        - common behaviour for models with UUID token attributes
* HasVotes        - pulls in ActsAsVotable, plus method to get URL-safe class name
* SoftDelete      - adds soft delete (from acts_as_paranoid gem)

* HasSlug                - for models with a slug attribute (usually for URLs)
* HasSlugUniqueInMonth   - slug is only unique within a month (includes HasSlug)
* HasSlugUniqueInSection - slug is only unique within a section (includes HasSlug)

* ProvidesDemoSiteData   - for models that may provide data for the demo site
* ProvidesSitemapData    - for models that may provide data for the sitemap

* Post            - common behaviour for 'posts' (e.g. ShinyBlog::Post, ShinyNews::Post) (includes CanHide, HasReadableName, HasSlugUniqueInMonth, HasTags, HasTeaser, HasVotes, and SoftDelete)

#### Templates and templated content

* Template        - common attributes and behaviour for any kind of layout template
* HTMLTemplate    - HTML-based layout templates (e.g. ShinyPages::Template) (includes Template)
* MJMLTemplate    - MJML-based layout templates (e.g. ShinyNewsletters::Template) (includes Template)

* HasTemplate     - content that has its layout defined by a template (e.g. ShinyPages::Page, ShinyNewsletters::Edition)

* Element         - common behaviour for elements of templates and templated content
* TemplateElement - elements of a layout template (e.g. ShinyPages::TemplateElement, ShinyNewsletters::TemplateElement) (includes Element)


### In feature plugins

* ShinySearch::Searchable - for models that want to be discoverable by the search feature
