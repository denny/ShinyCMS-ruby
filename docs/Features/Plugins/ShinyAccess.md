# ShinyCMS Plugins

## ShinyAccess

This plugin provides access control features to a site built on ShinyCMS (as opposed to access control for the admin area, which is built-in).

### Admin Area

With ShinyAccess loaded you can create Access Groups, and add/remove a user's membership of those groups.

### Main Site

You can use the `current_user_has_access( :access_group_slug )` helper method to grant or refuse access to content in your view templates - anything from hiding the entire page and redirecting, down to showing or hiding images, paragraphs, or even individual words.
