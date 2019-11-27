# This file contains any data which is either necessary to get ShinyCMS running,
# or which might provide useful hints for configuration after that.
#
# It is used to populate the databse when you create it with `rake db:setup`
# You can also load it (and reload it) at any time using `rake db:seed`

## Settings

# Feature flags
seed Setting, { name: I18n.t( 'settings.features.users.can_register' ) }, {
  value: 'Yes',
  description: "Set this to 'Yes' to allow users to create accounts"
}
seed Setting, { name: I18n.t( 'settings.features.users.can_login' ) }, {
  value: 'Yes',
  description: "Set this to 'Yes' to allow users to log in"
}

# Restrict admin area access to specific IP addresses
seed Setting, { name: I18n.t( 'settings.admin_ip_list' ) }, {
  value: '',
  description: 'Comma/space-separated list of IP addresses allowed to access admin area'
}

# Default page, default section. If page is set, section is ignored.
seed Setting, { name: I18n.t( 'settings.default_page' ) }, {
  value: '',
  description: 'Default top-level page (either its name or its slug)'
}
seed Setting, { name: I18n.t( 'settings.default_section' ) }, {
  value: '',
  description: 'Default top-level section (either its name or its slug)'
}
