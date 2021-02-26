# ShinyCMS Developer Documentation

## Supporting code: other modules

### In the core plugin

Location: `plugins/ShinyCMS/app/lib/shinycms/`

* ShinyCMS::DemoSiteData - methods used by the shinycms:demo:* rake tasks to import or export the demo site data

* ShinyCMS::MainAppRootURL - helper methods to return the root_url for the website, whether ShinyCMS is in charge of that path or not

* ShinyCMS::RouteDelegator - a mildly complicated routing bodge which helps ShinyCMS embed non-ShinyCMS engines into the ShinyCMS admin area, even if they weren't designed with that sort of embedded usage in mind
