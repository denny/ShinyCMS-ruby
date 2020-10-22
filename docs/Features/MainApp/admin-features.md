# ShinyCMS Features

## Admin features

### Admin area

The CMS has an admin area, imaginatively located at https://{your-domain-name}/admin

Any CMS feature (whether built-in or a plugin) that allows you update content or change settings will make itself available to you in this admin area - either by adding its own menu section, or by adding an item to the 'Other' menu section.

Plugins appear in the admin menu in the order that they are loaded; this can be specified by setting `SHINYCMS_PLUGINS` in your .env.* files or Heroku config vars (otherwise, the default behaviour is for all plugins to be loaded, in alphabetical order).


### Admin toolbar

If you are logged into a user account with suitable admin privileges, a toolbar will appear at the bottom of every page on the main sit. This toolbar will usually include some context-aware links to relevant admin features, allowing you to easily jump straight to the admin pages for the content you are currently looking at (assuming that you have the access to do so).


### Access Control List

Access to all of the admin features is controlled by a fine-grain ACL. You can add/remove capabilities from an individual user on their Edit User page, granting or removing access to particular features or sets of features.
