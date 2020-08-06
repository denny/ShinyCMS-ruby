# frozen_string_literal: true

module ShinyForms
  FactoryBot.define do
    factory :form_admin, parent: :admin_user do
      after :create do |admin|
        category = CapabilityCategory.find_by( name: 'forms' )

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
end
