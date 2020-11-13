# ShinyCMS Developer Documentation

## Rake tasks

ShinyCMS includes some rake tasks which are only useful to people developing new CMS features.

### Demo site data

```
rails shiny:demo:dump    # ShinyCMS: dump current database content into db/demo_data.rb
```

The dump task is useful if you are a developer who is adding a new feature to ShinyCMS, and you want to add some demo data for it.
