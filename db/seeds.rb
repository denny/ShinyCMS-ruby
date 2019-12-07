# This file contains any data which is either necessary to get ShinyCMS running,
# or which might provide useful hints for configuration after that.
#
# It is used to populate the databse when you create it with `rake db:setup`
# You can also load it (and reload it) at any time using `rake db:seed`

# Add some (unset) settings, to prompt people to set them
# TODO: replace this with the half-planned site/admin/user overrideable thing
seed Setting, { name: I18n.t( 'settings.admin_ip_list' ) }, {
  value: '',
  description: 'Comma/space-separated list of IP addresses allowed to access admin area'
}
seed Setting, { name: I18n.t( 'settings.default_page' ) }, {
  value: '',
  description: 'Default top-level page (either its name or its slug)'
}
seed Setting, { name: I18n.t( 'settings.default_section' ) }, {
  value: '',
  description: 'Default top-level section (either its name or its slug)'
}

# Feature flags
seed FeatureFlag, { name: I18n.t( 'admin.features.user_login' ) }, {
  description: 'Allow users to log in',
  enabled: true,
  enabled_for_admins: true,
}
seed FeatureFlag, { name: I18n.t( 'admin.features.user_profiles' ) }, {
  description: 'Allow viewing of user profiles',
  enabled: true,
  enabled_for_admins: true,
}
seed FeatureFlag, { name: I18n.t( 'admin.features.user_registration' ) }, {
  description: 'Allow users to create accounts',
  enabled: true,
  enabled_for_admins: true,
}

# Capabilities (for user authorisation)
cc = seed CapabilityCategory, { name: 'Admin' }

seed Capability, { name: 'View admin area' }, {
  category_id: cc.id,
}
