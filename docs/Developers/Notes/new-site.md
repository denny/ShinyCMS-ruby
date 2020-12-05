# ShinyCMS Developer Notes

## Steps currently required to create and deploy a new site on Heroku

I'm creating a copy of a simple site that is currently hosted on the Perl version of ShinyCMS:
* to identify any missing bits of functionality in the existing features and plugins
* to identify any steps that could usefully be partly or fully automated

(And, if the client agrees to swap them over for a month once it's all working, to do a running costs comparison vs. my leased server with a dozen ShinyCMS sites on it.)

### 1. Create a private repo and copy ShinyCMS into it

> This step is only necessary for building and deploying a production site based on ShinyCMS for a client who does not want their site assets (templates, images, etc) in a public repo on GitHub.
>
> If you want to just want to try ShinyCMS out and play with the demo site initially, then you can just fork the repo normally.
>
> If you're considering doing ShinyCMS development then you must fork the repo normally, otherwise contributing your changes back is going to be a PITA :)

First, create an empty private GitHub repo for your new site:  
https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/creating-a-new-repository

Then copy ShinyCMS into it:
```bash
# Fetch a bare copy of the ShinyCMS code
git clone --bare https://github.com/denny/ShinyCMS-ruby.git
# Mirror-push to the new repository
cd ShinyCMS-ruby.git
git push --mirror https://github.com/{your-username}/{your-site-name}.git
# Remove the temporary copy you created earlier
cd ..
rm -rf ShinyCMS-ruby.git
# Fetch your new repo
git clone git@github.com:{your-username}/{your-site-name}.git
cd {your-site-name}
```

### 2. Remove the themes included with the CMS

... unless you're using one of them, in which case skip step 3.

```bash
git rm -r themes/*
```

### 3. Create new theme

```bash
# Pretty much every site will have some 'brochure' pages, and custom header and footer content
mkdir -p themes/{site-name}/views/shiny_pages/pages
mkdir -p themes/{site-name}/views/includes
# If you're not happy with the default layout, you can override that in here
mkdir -p themes/{site-name}/views/layouts
# You only need the next one if your new site will be using the ShinyNewsletters plugin
mkdir -p themes/{site-name}/views/shiny_newsletters/newsletter_mailer

# Page templates; most sites will want one for homepage and at least one for other pages
touch themes/{site-name}/views/shiny_pages/pages/homepage-template.html.erb
touch themes/{site-name}/views/shiny_pages/pages/standard-page-template.html.erb
# Partials for top and bottom of page - most sites will probably want to override these
touch themes/{site-name}/views/includes/_header.html.erb
touch themes/{site-name}/views/includes/_footer.html.erb
# Layout - if the default one isn't right for you, override it here
touch themes/{site-name}/views/layouts/main_site.html.erb
# Newsletter templates - at least one pair (MJML for HTML part, ERB for plain text part)
touch themes/{site-name}/views/shiny_newsletters/newsletter_mailer/newsletter-template.html.mjml
touch themes/{site-name}/views/shiny_newsletters/newsletter_mailer/newsletter-template.text.erb
```

### 4. Build your site locally

* Figure out what ENV settings you want/need in .env.development.local
    * Some of these will feed into setting your config vars on Heroku later
* Set up the Site Settings and Feature Flags appropriately
* Fill out those template files that got touched above
    * And create any more that you need
* Create the Page Templates and Pages in the CMS admin area
    * Likewise for Newsletter Templates, if you're using that feature
* etc etc

### 5. Create new Heroku pipeline, with staging and production apps

* Connect pipeline to new GitHub repo
* Add Postgres and Redis add-ons to each app
* Set as many config vars as possible (copypasta desired var names from docs/env.sample)
* ...

### 6. Set up AWS S3 buckets (and AWS IAM access keys) for files and feeds

Files may be uploaded by ShinyPages, ShinyInserts, ShinyBlog, ShinyNews, and ShinyProfiles. The current default S3 settings for permissions etc are correct for the files bucket.

ShinyBlog and ShinyNews will generate Atom feeds. The feeds bucket needs to be made public.

S3:  https://s3.console.aws.amazon.com/s3/home

IAM: https://console.aws.amazon.com/iam/home

##### 6b. Optionally, add CNAME entries to DNS for some/all buckets

For this to work, AWS docs say that the bucket name must match the FQDN, e.g. files.example.com

Your CNAME entry is then files -> files.example.com.s3.{aws-region}.amazonaws.com

If you don't set up custom AWS S3 subdomains, your files and feeds will be served directly from AWS subdomains of the same format - {bucket-name}.s3.{aws-region}.amazonaws.com

> If you want the main site to serve over SSL, without paying Heroku extra for the privilege, you'll need to proxy it via Cloudflare and use their enforce_ssl feature. The code for URL generation in mailers and feeds has a small hack to support this approach; the _url helpers in these areas of the CMS default to HTTPS unless you explicitly override that with a config var. NB: This set-up does not mean that Heroku serves your site over SSL! People can still reach the bare herokuapps domain, if they know or guess it, over HTTP.
