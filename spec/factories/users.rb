FactoryBot.define do
  factory :user do
    username     { Faker::Internet.unique.username }
    email        { Faker::Internet.unique.email    }
    password     { Faker::Internet.password        }
    confirmed_at { Time.current                    }
  end

  factory :admin_user, parent: :user do
    after :create do |admin|
      view = create :capability, name: I18n.t( 'capability.view_admin_area' )
      create :user_capability, user_id: admin.id, capability_id: view.id
    end
  end

  factory :page_admin, parent: :admin_user do
    after :create do |admin|
      list   = create :capability, name: I18n.t( 'capability.list_pages'   )
      add    = create :capability, name: I18n.t( 'capability.add_pages'    )
      edit   = create :capability, name: I18n.t( 'capability.edit_pages'   )
      delete = create :capability, name: I18n.t( 'capability.delete_pages' )

      create :user_capability, user_id: admin.id, capability_id: list.id
      create :user_capability, user_id: admin.id, capability_id: add.id
      create :user_capability, user_id: admin.id, capability_id: edit.id
      create :user_capability, user_id: admin.id, capability_id: delete.id

      list   = create :capability, name: I18n.t( 'capability.list_sections'   )
      add    = create :capability, name: I18n.t( 'capability.add_sections'    )
      edit   = create :capability, name: I18n.t( 'capability.edit_sections'   )
      delete = create :capability, name: I18n.t( 'capability.delete_sections' )

      create :user_capability, user_id: admin.id, capability_id: list.id
      create :user_capability, user_id: admin.id, capability_id: add.id
      create :user_capability, user_id: admin.id, capability_id: edit.id
      create :user_capability, user_id: admin.id, capability_id: delete.id
    end
  end

  factory :page_template_admin, parent: :page_admin do
    after :create do |admin|
      list   = create :capability, name: I18n.t( 'capability.list_page_templates'   )
      add    = create :capability, name: I18n.t( 'capability.add_page_templates'    )
      edit   = create :capability, name: I18n.t( 'capability.edit_page_templates'   )
      delete = create :capability, name: I18n.t( 'capability.delete_page_templates' )

      create :user_capability, user_id: admin.id, capability_id: list.id
      create :user_capability, user_id: admin.id, capability_id: add.id
      create :user_capability, user_id: admin.id, capability_id: edit.id
      create :user_capability, user_id: admin.id, capability_id: delete.id
    end
  end

  # TODO: user factory you can pass an array of admin types into (see below)
  factory :settings_admin, parent: :admin_user do
    after :create do |admin|
      list   = create :capability, name: I18n.t( 'capability.list_settings'   )
      add    = create :capability, name: I18n.t( 'capability.add_settings'    )
      edit   = create :capability, name: I18n.t( 'capability.edit_settings'   )
      delete = create :capability, name: I18n.t( 'capability.delete_settings' )

      create :user_capability, user_id: admin.id, capability_id: list.id
      create :user_capability, user_id: admin.id, capability_id: add.id
      create :user_capability, user_id: admin.id, capability_id: edit.id
      create :user_capability, user_id: admin.id, capability_id: delete.id
    end
  end

  factory :shared_content_admin, parent: :admin_user do
    after :create do |admin|
      list   = create :capability, name: I18n.t( 'capability.list_shared_content'   )
      add    = create :capability, name: I18n.t( 'capability.add_shared_content'    )
      edit   = create :capability, name: I18n.t( 'capability.edit_shared_content'   )
      delete = create :capability, name: I18n.t( 'capability.delete_shared_content' )

      create :user_capability, user_id: admin.id, capability_id: list.id
      create :user_capability, user_id: admin.id, capability_id: add.id
      create :user_capability, user_id: admin.id, capability_id: edit.id
      create :user_capability, user_id: admin.id, capability_id: delete.id
    end
  end

  factory :user_admin, parent: :admin_user do
    after :create do |admin|
      list   = create :capability, name: I18n.t( 'capability.list_users'   )
      add    = create :capability, name: I18n.t( 'capability.add_users'    )
      edit   = create :capability, name: I18n.t( 'capability.edit_users'   )
      delete = create :capability, name: I18n.t( 'capability.delete_users' )

      create :user_capability, user_id: admin.id, capability_id: list.id
      create :user_capability, user_id: admin.id, capability_id: add.id
      create :user_capability, user_id: admin.id, capability_id: edit.id
      create :user_capability, user_id: admin.id, capability_id: delete.id
    end
  end

  factory :super_admin, parent: :user_admin do
    after :create do |admin|
      list   = create :capability, name: I18n.t( 'capability.list_admins'   )
      add    = create :capability, name: I18n.t( 'capability.add_admins'    )
      edit   = create :capability, name: I18n.t( 'capability.edit_admins'   )
      delete = create :capability, name: I18n.t( 'capability.delete_admins' )

      create :user_capability, user_id: admin.id, capability_id: list.id
      create :user_capability, user_id: admin.id, capability_id: add.id
      create :user_capability, user_id: admin.id, capability_id: edit.id
      create :user_capability, user_id: admin.id, capability_id: delete.id
    end
  end
end
