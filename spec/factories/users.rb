# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for User model (note, plugins tend to add to this collection)
FactoryBot.define do
  factory :user do
    username     { Faker::Internet.unique.username }
    password     { Faker::Internet.unique.password }
    email        { Faker::Internet.unique.email( name: username ) }
    confirmed_at { Time.current }
  end

  factory :admin_user, parent: :user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'general' )
      capability1 = category.capabilities.find_by( name: 'view_admin_area'    )
      capability2 = category.capabilities.find_by( name: 'view_admin_toolbar' )
      create :user_capability, user: admin, capability: capability1
      create :user_capability, user: admin, capability: capability2
    end
  end

  # TODO: user factory you can pass an array of admin types into,
  # to create all of the following (and mixtures) with less repetition...

  factory :discussion_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'discussions' )

      show   = category.capabilities.find_by( name: 'show'   )
      hide   = category.capabilities.find_by( name: 'hide'   )
      lock   = category.capabilities.find_by( name: 'lock'   )
      unlock = category.capabilities.find_by( name: 'unlock' )

      create :user_capability, user: admin, capability: show
      create :user_capability, user: admin, capability: hide
      create :user_capability, user: admin, capability: lock
      create :user_capability, user: admin, capability: unlock

      category = CapabilityCategory.find_by( name: 'comments' )

      show    = category.capabilities.find_by( name: 'show'   )
      hide    = category.capabilities.find_by( name: 'hide'    )
      lock    = category.capabilities.find_by( name: 'lock'    )
      unlock  = category.capabilities.find_by( name: 'unlock'  )
      destroy = category.capabilities.find_by( name: 'destroy' )

      create :user_capability, user: admin, capability: show
      create :user_capability, user: admin, capability: hide
      create :user_capability, user: admin, capability: lock
      create :user_capability, user: admin, capability: unlock
      create :user_capability, user: admin, capability: destroy

      category = CapabilityCategory.find_by( name: 'spam_comments' )

      list    = category.capabilities.find_by( name: 'list'    )
      add     = category.capabilities.find_by( name: 'add'     )
      destroy = category.capabilities.find_by( name: 'destroy' )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: destroy
    end
  end

  factory :email_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'email_previews' )

      list = category.capabilities.find_by( name: 'list' )
      show = category.capabilities.find_by( name: 'show' )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: show
    end
  end

  factory :feature_flags_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'feature_flags' )

      list    = category.capabilities.find_by( name: 'list'    )
      edit    = category.capabilities.find_by( name: 'edit'    )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: edit
    end
  end

  factory :stats_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'stats' )

      web     = category.capabilities.find_by( name: 'view_web'    )
      email   = category.capabilities.find_by( name: 'view_email'  )
      charts1 = category.capabilities.find_by( name: 'view_charts' )
      charts2 = category.capabilities.find_by( name: 'make_charts' )

      create :user_capability, user: admin, capability: web
      create :user_capability, user: admin, capability: email
      create :user_capability, user: admin, capability: charts1
      create :user_capability, user: admin, capability: charts2
    end
  end

  factory :settings_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'settings' )

      list    = category.capabilities.find_by( name: 'list'    )
      edit    = category.capabilities.find_by( name: 'edit'    )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: edit
    end
  end

  factory :user_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'users' )

      list    = category.capabilities.find_by( name: 'list'    )
      add     = category.capabilities.find_by( name: 'add'     )
      edit    = category.capabilities.find_by( name: 'edit'    )
      destroy = category.capabilities.find_by( name: 'destroy' )
      notes   = category.capabilities.find_by( name: 'view_admin_notes' )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy
      create :user_capability, user: admin, capability: notes
    end
  end

  factory :super_admin, parent: :user_admin do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'admin_users' )

      list    = category.capabilities.find_by( name: 'list'    )
      add     = category.capabilities.find_by( name: 'add'     )
      edit    = category.capabilities.find_by( name: 'edit'    )
      destroy = category.capabilities.find_by( name: 'destroy' )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy
    end
  end
end
