# This file contains any data which is either necessary to get ShinyCMS running,
# or which might provide useful hints for configuration after that.
#
# It is used to populate the databse when you create it with `rake db:setup`
# You can also load it (and reload it) at any time using `rake db:seed`

# Settings
seed Setting, { name: I18n.t( 'default_page'    ) }, { value: '[not set]' }
seed Setting, { name: I18n.t( 'default_section' ) }, { value: '[not set]' }
