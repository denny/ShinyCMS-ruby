# ShinyCMS: Themes

The recommended way to start building a new site on ShinyCMS is to create a theme for it (unless you intend to use one of the default themes, with no modifications and no additional templates required).

## Making a theme

ShinyCMS falls back to the default template set whenever a template it needs is not present in the currently configured theme - which means that you can start building your own theme by simply creating a subdirectory for it in `/themes` - e.g. `/themes/my_site_name`. Even an empty directory is a valid theme (although not a very interesting one) :)

> Because themes are based on a directory in the `/themes` folder, valid theme names must be valid directory names on whatever operating system you intend to deploy ShinyCMS on. Something in `snake_case` is a safe bet on most platforms... e.g. `/themes/my_site_name`

Keeping your site's changes separated out into your own theme means that you can fetch future updates to the ShinyCMS default templates without that overwriting any customisations you have made to templates for your own site. Instead, the new default templates can be used as a reference guide for any updates you might need to make to your theme templates.

### Overriding the default templates

Once you've created your theme directory, create a views directory inside it - e.g. `themes/my_site_name/views/` - then copy any template that you want to edit or override into that directory and make your desired changes. ShinyCMS will give templates in your theme preference over the default templates whenever you tell it to use your theme.

Your theme templates need to be kept in the same structure they have in the main app and plugin `app/views` folders for the overriding to work correctly. For example, if you are overriding the main site footer template then you would start with `cp app/views/shinycms/includes/_footer.html.erb themes/my_site_name/views/includes/`. If you're overriding the index page for the ShinyBlog plugin, you would start with `cp plugins/ShinyBlog/app/views/shiny_blog/blog/index.html.erb themes/my_site_name/views/shiny_blog/blog/`.

### Creating template files for templated content (Pages, Newsletters)

You will need to create your own template files for any template-controlled content you have in the CMS, and create the appropriate Template entries in the admin area. For most people this will include the Templates to define the layout of the content section of your [Pages](Plugins/ShinyPages), and if you're using the [Newsletters](Plugins/ShinyNewsletters) feature you'll need to create at least one pair of Templates (MJML and plain text) for the content section of those.

There are sample templates for both of these features in the included Halcyonic theme, to get you started.

### Supporting files

#### Images and stylesheets

You should put theme-specific CSS into `themes/{theme_name}/stylesheets` and images into `themes/{theme_name}/images` - so for our example 'my_site_name' theme, these would be `themes/my_site_name/stylesheets` and `themes/my_site_name/images`.

#### JavaScript

Currently, if your theme needs some JavaScript then you should put the files in `themes/javascript/my_site_name`, and configure Webpacker to load it by adding a file in `/app/javascript/packs` containing `require( 'my_site_name' )`.

Eventually the plan is that theme JavaScript will go in `/themes/my_site_name/javascript` and be loaded automatically, but dynamically adding things to Webpacker's config seems to be difficult, so for now this is how it works. :-\


## Using your theme

The default theme can be set in ENV['SHINYCMS_THEME'] and on the Settings page in the admin area. If both are set, the latter takes priority.

You can also choose to make this setting user-overridable, in which case a user's setting will take priority for them - but this configuration is experimental and currently untested.
