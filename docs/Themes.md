# ShinyCMS: Themes

The recommended way to start building a site on ShinyCMS is to create a theme
for it... this keeps your own site's markup separate from the CMS templates,
making it easier to apply future updates.


## Making a theme

### Templates

The ShinyCMS theme engine falls back to the default template set if a template
is not present in the current theme, which means that you can start building
your own theme by simply creating a subdirectory for it in `app/views/themes` -
e.g. `app/views/themes/my_site`. Even an empty directory is a valid theme!

> Because themes start with a directory in the themes folder, valid theme names
must be valid directory names on whatever operating system you intend to deploy
ShinyCMS on. Something in snake-case like `my_theme_name` is usually a safe bet.

Once you've created your theme directory, you can copy any template that you
want to edit or override into that directory from `app/views/shinycms`, and
then edit the copied versions. ShinyCMS will pick up your modified version
whenever you tell it to use your theme.

This system allows you to pick up any updates to the ShinyCMS core templates,
with minimal risk of that conflicting with your own customisations to your
site's appearance.

### Supporting files (images, stylesheets, JavaScript)

If your theme requires any images, you should create a directory for them in
`app/assets/images` with the same name as your theme, and likewise you should
put theme-specific CSS into a directory in `app/assets/stylesheets` - for our
example 'my_site' theme, these would be `app/assets/images/my_site` and
`app/assets/stylesheets/my_site`. You'll need to add these directories to
`app/assets/config/manifest.js` to get Rails to pick them up.

If your theme needs some JavaScript, that goes in `app/javascript/theme_name`,
and is loaded by Webpacker (based on the files in `app/javascript/packs`).


## Using your theme

The default theme can be set in ENV['SHINYCMS_THEME'] and on the Settings page
in the admin area. If both are set, the latter takes priority. You can also
choose to make this setting user-overridable, in which case a user's setting
will take priority for them.
