# ShinyCMS: Themes

The recommended way to start building a site on ShinyCMS is to create a theme for it... this keeps your own site's markup separate from the CMS templates, making it easier to apply future updates.


## Making a theme

### Template files

The ShinyCMS theme engine falls back to the default template set if a template is not present in the current theme, which means that you can start building your own theme by simply creating a subdirectory for it in `app/views/themes` - e.g. `app/views/themes/my_site_name`. Even an empty directory is a valid theme!

> Because themes start with a directory in the themes folder, valid theme names must be valid directory names on whatever operating system you intend to deploy ShinyCMS on. Something in snake-case is a safe bet on most platforms.

Once you've created your theme directory, you can copy any template that you want to edit or override into that directory from `app/views/shinycms`, and then edit the copied versions. ShinyCMS will pick up your modified version instead, whenever you tell it to use your theme.

This system allows you to fetch future updates to the ShinyCMS default templates without that overwriting any customisations you have made to templates for your own site. Instead, the new templates can be used as a reference guide for any changes you might need to make to your own templates. It also means that making multiple variations on an existing theme should be very quick and easy.

#### Template files for templated content (Pages, Newsletters)

You will need to create your own template files for any template-controlled content you have in the CMS, and create the appropriate Template entries in the admin area. For most people this will include the Templates to define the layout of the content section of your [Pages](Plugins/ShinyPages), and if you're using the [Newsletters](Plugins/ShinyNewsletters) feature you'll need to create at least one pair (MJML and plain text) of Templates for the content section of those.

There are sample templates for both of these features in the included Halcyonic theme, to get you started.

### Supporting files (images, stylesheets, JavaScript)

Currently, you should put theme-specific CSS into a directory in `vendor/assets/stylesheets` with the same name as your theme, and if your theme requires any images, you should create a directory for them in `vendor/assets/images` - so for our example 'my_site_name' theme, these would be `vendor/assets/images/my_site_name` and `vendor/assets/stylesheets/my_site_name`. You'll need to add these directories to `app/assets/config/manifest.js` to get Rails to pick them up.

Similarly, if your theme needs some JavaScript, that goes in `vendor/javascript/my_site_name`, and is loaded by Webpacker based on the files in `app/javascript/packs`.

(Eventually the CMS will pick up theme assets automatically, but for now this is how it works.)


## Using your theme

The default theme can be set in ENV['SHINYCMS_THEME'] and on the Settings page in the admin area. If both are set, the latter takes priority.

(You can also choose to make this setting user-overridable - in which case a user's setting will take priority for them - but this is not a well-tested feature currently.)
