# Getting Started

## Installing

...

## Configuration

...

## Creating your site

### Themes

The recommended way to start building a site on ShinyCMS is to create a theme
for it. The ShinyCMS theme engine falls back to the default template set if a
template is not present in the current theme, which means that you can start
building your own theme by simply creating a subdirectory for it in 
`app/views/themes`. Then you can copy any template that you wish to edit or
override from `app/views/shinycms` into your new theme directory and ShinyCMS
will pick up your modified version whenever you tell it to use your theme.

The current theme can be set in ENV['SHINYCMS_THEME'] and on the Settings page
in the admin area. If both are set, the latter takes priority.
