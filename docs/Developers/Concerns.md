# ShinyCMS Developer Documentation

## Concerns

There are a number of concerns provided with ShinyCMS. These are intended to make it easier for people to build new features that work similarly to the existing features, from both a user and developer perspective.

### In the main app

* ShinyClassName        - return a 'human friendly', translatable version of model's class name
* ShinyDemoDataProvider - identifies models that may provide data to the demo site
* ShinyEmail            - sets/searches/validates models by canonical_email as well as email
* ShinyName             - .name method, returns public_name if one is set, internal_name otherwise
* ShinyPaging           - enables pagination features (from kaminari) when included
* ShinyShowHide         - check or change show/hide status of content on the site/in menus/etc
* ShinySoftDelete       - enables soft delete features (from acts_as_paranoid) when included
* ShinyTeaser           - generate a truncated 'teaser' of a longer post, and related methods
* ShinyToken            - generate/reset/check UUID token attributes with optional expiry times

* ShinySlug          - for models with a URL slug attribute
* ShinySlugInMonth   - enforces slug uniqueness within each month   (includes ShinySlug)
* ShinySlugInSection - enforces slug uniqueness within each section (includes ShinySlug)

* ShinyPost - common behaviour for 'posts' (includes ShinyClassName, ShinyPaging, ShinyShowHide, ShinySlugInMonth, ShinySoftDelete, ShinyTeaser) (included by ShinyBlog::Post, ShinyNews::Post)

* ShinyWithTemplate - for models that use a template for layout (included by ShinyPages::Page, ShinyNewsletters::Edition)
* ShinyElement      - for models that are elements of templates or templated content

* ShinyTemplate     - common attributes and behaviours for models that are any kind of layout template
* ShinyHTMLTemplate - for HTML-based layout templates (includes ShinyTemplate) (included by ShinyPages::Template)
* ShinyMJMLTemplate - for MJML-based layout templates (includes ShinyTemplate) (included by ShinyNewsletters::Template)
* ShinyTemplateElement - for models that are elements of a layout template (includes ShinyElement) (included by ShinyPages::TemplateElement, ShinyNewsletters::TemplateElement)

At some point in the future, most of these Concerns will probably move into some sort of ShinyTools plugin or plugins (which can then be depended on by whichever other plugins need them), as part of the long-term plan to move most or all of the main app code into plugins.

### In plugins

* ShinySearch::Searchable - for models that want to be discoverable by the search feature
