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
seed FeatureFlag, { name: I18n.t( 'features.user_login' ) }, {
  description: 'Allow users to log in',
  enabled: true,
  enabled_for_admins: true,
}
seed FeatureFlag, { name: I18n.t( 'features.user_profiles' ) }, {
  description: 'Allow viewing of user profiles',
  enabled: true,
  enabled_for_admins: true,
}
seed FeatureFlag, { name: I18n.t( 'features.user_registration' ) }, {
  description: 'Allow users to create accounts',
  enabled: true,
  enabled_for_admins: true,
}

# Capabilities (for user authorisation)
general_cc = seed CapabilityCategory, { name: 'capability.general_category' }
users_cc   = seed CapabilityCategory, { name: 'capability.users_category'   }
# General
seed Capability, { name: I18n.t( 'capability.view_admin_area'    ) }, {
  category_id: general_cc.id,
}
seed Capability, { name: I18n.t( 'capability.view_admin_toolbar' ) }, {
  category_id: general_cc.id,
}
# Users
seed Capability, { name: I18n.t( 'capability.list_users'  ) }, {
  category_id: users_cc.id,
}
seed Capability, { name: I18n.t( 'capability.add_users'   ) }, {
  category_id: users_cc.id,
}
seed Capability, { name: I18n.t( 'capability.edit_users'  ) }, {
  category_id: users_cc.id,
}
seed Capability, { name: I18n.t( 'capability.edit_admins' ) }, {
  category_id: users_cc.id,
}
