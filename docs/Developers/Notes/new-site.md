# ShinyCMS Developer Notes

## Steps currently required to create and deploy a new site

### Create a private copy of the main repo

https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/duplicating-a-repository

### Remove included themes

`git rm -r app/views/themes/*

### Create new theme

```bash
# Pretty much every site will have some 'brochure' pages, and tweak header and footer content
mkdir -p app/views/themes/{site-name}/shiny_pages/pages
mkdir -p app/views/themes/{site-name}/includes
# If you're not happy with the default layout, you can override that here
mkdir -p app/views/themes/{site-name}/layouts
# You only need the next one if your new site will be using the ShinyNewsletters plugin
mkdir -p app/views/themes/{site-name}/shiny_newsletters/newsletter_mailer
touch app/views/themes/{site-name}/layouts/main_site.html.erb

# Page templates; most sites will want one for homepage and at least one for other pages
touch app/views/themes/{site-name}/shiny_pages/pages/homepage-template.html.erb
touch app/views/themes/{site-name}/shiny_pages/pages/standard-page-template.html.erb
# Partials for top and bottom of page - most sites will probably want to override these
touch app/views/themes/{site-name}/includes/_header.html.erb
touch app/views/themes/{site-name}/includes/_footer.html.erb
# Layout
touch app/views/themes/{site-name}/layouts/main_site.html.erb
# Newsletter templates - at least one pair (MJML for HTML part, ERB for plain text part)
touch app/views/themes/{site-name}/shiny_newsletters/newsletter_mailer/newsletter-template.html.mjml
touch app/views/themes/{site-name}/shiny_newsletters/newsletter_mailer/newsletter-template.text.erb
```

### Create new Heroku pipeline, with staging and production apps

* Connect pipeline to new GitHub repo
* Add Postgres and Redis add-ons to each app
* Set as many config vars as possible (copypasta desired var names from docs/env.sample)
* ...

### Set up AWS S3 buckets for staging and production files, and feeds if needed

(Files may be uploaded by ShinyPages, ShinyBlog, ShinyNews, ShinyInserts, and ShinyProfiles. ShinyBlog and ShinyNews will also generate feeds.)
