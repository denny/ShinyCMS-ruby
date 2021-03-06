# ShinyCMS Developer Documentation

## Rake tasks

ShinyCMS includes some rake tasks which are probably only useful to people developing new CMS features.

### Demo site data

```
rails shinycms:demo:export    # ShinyCMS: export current database content into db/demo_site_data.rb
```

This export task is useful if you are a developer who is adding a new feature to ShinyCMS, and you want to add some demo data for that new feature, to make it easier for people to try it out.
