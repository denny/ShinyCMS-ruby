# This file contains any data which is either necessary to get ShinyCMS running,
# or which might provide useful hints for configuration after that.
#
# It is used to populate the databse when you create it with `rake db:setup`
# You can also load it (and reload it) at any time using `rake db:seed`

# Add some (unset) settings, to prompt people to set them
# TODO: replace this with the half-planned site/admin/user overrideable thing
seed Setting, { name: I18n.t( 'admin.settings.admin_ip_list' ) }, {
  value: '',
  description: 'Comma/space-separated list of IP addresses allowed to access admin area'
}
seed Setting, { name: I18n.t( 'admin.settings.default_page' ) }, {
  value: '',
  description: 'Default top-level page (either its name or its slug)'
}
seed Setting, { name: I18n.t( 'admin.settings.default_section' ) }, {
  value: '',
  description: 'Default top-level section (either its name or its slug)'
}

# Feature Flags (to turn on/off areas of site functionality)
seed FeatureFlag, { name: I18n.t( 'feature_flags.user_login' ) }, {
  description: 'Allow users to log in',
  enabled: false,
  enabled_for_admins: true,
}
seed FeatureFlag, { name: I18n.t( 'feature_flags.user_profiles' ) }, {
  description: 'Allow viewing of user profiles',
  enabled: true,
  enabled_for_admins: true,
}
seed FeatureFlag, { name: I18n.t( 'feature_flags.user_registration' ) }, {
  description: 'Allow users to create accounts',
  enabled: true,
  enabled_for_admins: true,
}

# Capabilities (for user authorisation via Pundit)
general_cc   = seed CapabilityCategory, { name: 'general'        }
pages_cc     = seed CapabilityCategory, { name: 'pages'          }
sections_cc  = seed CapabilityCategory, { name: 'page_sections'  }
templates_cc = seed CapabilityCategory, { name: 'page_templates' }
shared_cc    = seed CapabilityCategory, { name: 'shared_content' }
users_cc     = seed CapabilityCategory, { name: 'users'          }
admins_cc    = seed CapabilityCategory, { name: 'admin_users'    }
# General
seed Capability, { name: 'view_admin_area'    }, { category: general_cc }
seed Capability, { name: 'view_admin_toolbar' }, { category: general_cc }
# Pages
seed Capability, { name: 'list'   }, { category: pages_cc }
seed Capability, { name: 'add'    }, { category: pages_cc }
seed Capability, { name: 'edit'   }, { category: pages_cc }
seed Capability, { name: 'delete' }, { category: pages_cc }
# Page Sections
seed Capability, { name: 'list'   }, { category: sections_cc }
seed Capability, { name: 'add'    }, { category: sections_cc }
seed Capability, { name: 'edit'   }, { category: sections_cc }
seed Capability, { name: 'delete' }, { category: sections_cc }
# Page Templates
seed Capability, { name: 'list_page_templates'   }, { category_id: templates_cc.id }
seed Capability, { name: 'add_page_templates'    }, { category_id: templates_cc.id }
seed Capability, { name: 'edit_page_templates'   }, { category_id: templates_cc.id }
seed Capability, { name: 'delete_page_templates' }, { category_id: templates_cc.id }
# Shared Content
seed Capability, { name: 'list_shared_content'   }, { category_id: shared_cc.id }
seed Capability, { name: 'add_shared_content'    }, { category_id: shared_cc.id }
seed Capability, { name: 'edit_shared_content'   }, { category_id: shared_cc.id }
seed Capability, { name: 'delete_shared_content' }, { category_id: shared_cc.id }
# Users
seed Capability, { name: 'list_users'   }, { category_id: users_cc.id }
seed Capability, { name: 'add_users'    }, { category_id: users_cc.id }
seed Capability, { name: 'edit_users'   }, { category_id: users_cc.id }
seed Capability, { name: 'delete_users' }, { category_id: users_cc.id }
seed Capability, { name: 'view_user_admin_notes' }, { category_id: users_cc.id }
# Admin Users
seed Capability, { name: 'edit_admins'    }, { category_id: admins_cc.id }
seed Capability, { name: 'delete_admins'  }, { category_id: admins_cc.id }

# One Admin To Rule Them All
admin = seed User, { username: 'admin' }, {
  email: 'admin@example.com',
  password: 'I should change this password before I do anything else!'
}
admin.confirm
Capability.all.each do |c|
  admin.user_capabilities.create( capability_id: c.id )
end
