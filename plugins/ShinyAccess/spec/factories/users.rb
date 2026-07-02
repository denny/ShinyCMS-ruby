# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory to create an admin user for access control plugin
FactoryBot.define do
  factory :access_admin, parent: :admin_user do
    after :create do |admin|
      category = ShinyCMS::CapabilityCategory.find_by( name: 'access_groups' )

      list    = category.capabilities.find_by( name: 'list'    )
      add     = category.capabilities.find_by( name: 'add'     )
      edit    = category.capabilities.find_by( name: 'edit'    )
      destroy = category.capabilities.find_by( name: 'destroy' )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy

      category = ShinyCMS::CapabilityCategory.find_by( name: 'access_group_memberships' )

      list    = category.capabilities.find_by( name: 'list'    )
      add     = category.capabilities.find_by( name: 'add'     )
      destroy = category.capabilities.find_by( name: 'destroy' )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: destroy
    end
  end
end
