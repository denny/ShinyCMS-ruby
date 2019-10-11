# This file contains any data which is either necessary to get ShinyCMS running,
# or which might provide useful hints for configuration after that.
#
# It is used to populate the databse when you create it with `rake db:setup`
# You can also load it (and reload it) at any time using `rake db:seed`

# Settings
seed Setting, { name: I18n.t( 'default_page' ) }, {
  value: 'name or slug',
  description: 'Default top-level page (either its name or its slug)'
}
seed Setting, { name: I18n.t( 'default_section' ) }, {
  value: 'name or slug',
  description: 'Default top-level page (either its name or its slug)'
}
seed Setting, { name: I18n.t( 'admin_ip_whitelist' ) }, {
  value: '127.0.0.1, 10.10.10.10, 127.127.127.127',
  description: 'Comma/space-separated list of IP addresses allowed to access admin area'
}
