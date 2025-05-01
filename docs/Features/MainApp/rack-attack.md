# ShinyCMS Features

## Rack::Attack - filtering and blocking

Rack::Attack is used to defend ShinyCMS sites against at least some of the crushing waves of spammy bot traffic that plague the Internet now.

Currently it just quickly and silently drops traffic (with a 204 response code) from the very worst offenders, which seems to be a variety of bots looking for the admin area of WordPress sites, presumably to exploit. Suppressing the 404 errors that would otherwise be caused by this traffic makes it easier to spot more useful errors in your logs or monitoring, that you might actually want to (and be able to) fix.

### More information

You can read the [intro to Rack::Attack](https://kickstarter.engineering/rack-attack-protection-from-abusive-clients-4c188496293b) blogpost from Kickstarter.

And there are more details in the [Rack::Attack docs](https://github.com/rack/rack-attack?tab=readme-ov-file).

Here's the [ShinyCMS Rack::Attack config](plugins/ShinyCMS/config/initializers/rack_attack.rb)
