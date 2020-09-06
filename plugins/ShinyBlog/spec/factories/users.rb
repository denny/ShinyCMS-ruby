# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  FactoryBot.define do
    factory :blog_admin, parent: :admin_user do
      after :create do |admin|
        category = CapabilityCategory.find_by( name: 'blog_posts' )

        list    = category.capabilities.find_by( name: 'list'    )
        add     = category.capabilities.find_by( name: 'add'     )
        edit    = category.capabilities.find_by( name: 'edit'    )
        destroy = category.capabilities.find_by( name: 'destroy' )
        # author  = category.capabilities.find_by( name: 'author' )

        create :user_capability, user: admin, capability: list
        create :user_capability, user: admin, capability: add
        create :user_capability, user: admin, capability: edit
        create :user_capability, user: admin, capability: destroy
        # create :user_capability, user: admin, capability: author
      end
    end
  end
end
