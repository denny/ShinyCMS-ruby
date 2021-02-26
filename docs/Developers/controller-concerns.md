# ShinyCMS Developer Documentation

## Supporting code: controller concerns

There are several controller concerns provided with ShinyCMS. As with well as DRYing up common features, I hope these will make it easier for other developers to build new features that [work similarly][Why does this matter?] to the existing features (from both a user and developer perspective).

### In the core plugin

#### For main site controllers (or both)

* ShinyCMS::FeatureFlags
    * Provides the `enforce_feature_flags` method used in any controller which implements feature-flagged functionality

* ShinyCMS::Paging
    * Includes [Pagy](https://github.com/ddnexus/pagy#readme)::Backend, and provides a couple of helper methods for getting items-per-page values from params or defaults from settings
    * May well become obsolete once Pagy's [items extra](https://ddnexus.github.io/pagy/extras/items) is integrated - if the supporting methods go, it would be clearer to include Pagy::Backend directly in the controllers

* ShinyCMS::PasswordReportAction
    * Provides the `password_report` action, which can be mixed into any controller to provide a JSON endpoint for obtaining password reports containing complexity scores and advice (powered by [zxcvbn](https://github.com/envato/zxcvbn-ruby#readme))

* ShinyCMS::Votes
    * Provides `url_param_to_class_name` method, which reverses `name_to_url_param` from the ShinyCMS::HasVotes model concern.

#### For admin controllers only

* ShinyCMS::Admin::Discussions
    * Provides methods for dealing with the show/hide flags for discussions when editing a related resource
    * (This seems like poor separation of concerns - and it'll be even worse when Discussions gets its own plugin)

* ShinyCMS::Admin::Posts
    * Provides methods to handle attempts to set an author other than the logged-in user for e.g. a News Post (a capability controlled by the Pundit ACL)

* ShinyCMS::Admin::Sorting
    * Provides methods to help implement the drag-to-sort feature

* ShinyCMS::Admin::Tags
    * Provides a method to render tags or hidden tags (into the tag_list field on the edit page) depending on the show/hide status of the resource being edited
