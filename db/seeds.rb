# This file contains any data which is either necessary to get ShinyCMS running,
# or which might provide useful hints for configuration after that.
#
# It is used to populate the databse when you create it with `rake db:setup`
# You can also load it (and reload it) at any time using `rake db:seed`

# Add some (unset) settings, to prompt people to set them
# TODO: replace this with the half-planned site/admin/user overrideable thing
seed Setting, { name: I18n.t( 'setting.admin_ip_list' ) }, {
  value: '',
  description: 'Comma/space-separated list of IP addresses allowed to access admin area'
}
seed Setting, { name: I18n.t( 'setting.default_page' ) }, {
  value: '',
  description: 'Default top-level page (either its name or its slug)'
}
seed Setting, { name: I18n.t( 'setting.default_section' ) }, {
  value: '',
  description: 'Default top-level section (either its name or its slug)'
}

# Feature Flags (to turn on/off areas of site functionality)
seed FeatureFlag, { name: I18n.t( 'feature.user_login' ) }, {
  description: 'Allow users to log in',
  enabled: false,
  enabled_for_admins: true,
}
seed FeatureFlag, { name: I18n.t( 'feature.user_profiles' ) }, {
  description: 'Allow viewing of user profiles',
  enabled: true,
  enabled_for_admins: true,
}
seed FeatureFlag, { name: I18n.t( 'feature.user_registration' ) }, {
  description: 'Allow users to create accounts',
  enabled: true,
  enabled_for_admins: true,
}

# Capabilities (for user authorisation)
general_cc = seed CapabilityCategory, { name: 'capability.general'        }
pages_cc   = seed CapabilityCategory, { name: 'capability.pages'          }
shared_cc  = seed CapabilityCategory, { name: 'capability.shared_content' }
users_cc   = seed CapabilityCategory, { name: 'capability.users'          }
# General
seed Capability, { name: I18n.t( 'capability.view_admin_area'    ) }, {
  category_id: general_cc.id,
}
seed Capability, { name: I18n.t( 'capability.view_admin_toolbar' ) }, {
  category_id: general_cc.id,
}
# Pages
seed Capability, { name: I18n.t( 'capability.list_pages'   ) }, {
  category_id: pages_cc.id,
}
seed Capability, { name: I18n.t( 'capability.add_pages'    ) }, {
  category_id: pages_cc.id,
}
seed Capability, { name: I18n.t( 'capability.edit_pages'   ) }, {
  category_id: pages_cc.id,
}
seed Capability, { name: I18n.t( 'capability.delete_pages' ) }, {
  category_id: pages_cc.id,
}
# Page Sections
seed Capability, { name: I18n.t( 'capability.list_page_sections'   ) }, {
  category_id: pages_cc.id,
}
seed Capability, { name: I18n.t( 'capability.add_page_sections'    ) }, {
  category_id: pages_cc.id,
}
seed Capability, { name: I18n.t( 'capability.edit_page_sections'   ) }, {
  category_id: pages_cc.id,
}
seed Capability, { name: I18n.t( 'capability.delete_page_sections' ) }, {
  category_id: pages_cc.id,
}
# Page Templates
seed Capability, { name: I18n.t( 'capability.list_page_templates'   ) }, {
  category_id: pages_cc.id,
}
seed Capability, { name: I18n.t( 'capability.add_page_templates'    ) }, {
  category_id: pages_cc.id,
}
seed Capability, { name: I18n.t( 'capability.edit_page_templates'   ) }, {
  category_id: pages_cc.id,
}
seed Capability, { name: I18n.t( 'capability.delete_page_templates' ) }, {
  category_id: pages_cc.id,
}
# Shared Content
seed Capability, { name: I18n.t( 'capability.list_shared_content'   ) }, {
  category_id: shared_cc.id,
}
seed Capability, { name: I18n.t( 'capability.add_shared_content'    ) }, {
  category_id: shared_cc.id,
}
seed Capability, { name: I18n.t( 'capability.edit_shared_content'   ) }, {
  category_id: shared_cc.id,
}
seed Capability, { name: I18n.t( 'capability.delete_shared_content' ) }, {
  category_id: shared_cc.id,
}
# Users
seed Capability, { name: I18n.t( 'capability.list_users'   ) }, {
  category_id: users_cc.id,
}
seed Capability, { name: I18n.t( 'capability.add_users'    ) }, {
  category_id: users_cc.id,
}
seed Capability, { name: I18n.t( 'capability.edit_users'   ) }, {
  category_id: users_cc.id,
}
seed Capability, { name: I18n.t( 'capability.delete_users' ) }, {
  category_id: users_cc.id,
}
seed Capability, { name: I18n.t( 'capability.edit_admins'  ) }, {
  category_id: users_cc.id,
}

# One Admin To Rule Them All
admin = seed User, { username: 'admin' }, {
  password: 'I should change this password before I do anything else!!',
  email: 'admin@example.com'
}
admin.confirm
Capability.all.each do |c|
  admin.user_capabilities.create( capability_id: c.id )
end
