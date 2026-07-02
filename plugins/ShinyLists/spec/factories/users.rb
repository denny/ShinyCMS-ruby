# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory to create an admin user for mailing lists and list subscriptions
FactoryBot.define do
  factory :list_admin, parent: :admin_user do
    after :create do |admin|
      category = ShinyCMS::CapabilityCategory.find_by( name: 'mailing_lists' )

      list    = category.capabilities.find_by( name: 'list'    )
      add     = category.capabilities.find_by( name: 'add'     )
      edit    = category.capabilities.find_by( name: 'edit'    )
      destroy = category.capabilities.find_by( name: 'destroy' )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy

      category = ShinyCMS::CapabilityCategory.find_by( name: 'mailing_list_subscriptions' )

      list    = category.capabilities.find_by( name: 'list'    )
      add     = category.capabilities.find_by( name: 'add'     )
      destroy = category.capabilities.find_by( name: 'destroy' )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: destroy
    end
  end
end
