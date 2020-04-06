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
      capability = category.capabilities.find_by( name: 'view_admin_area' )
      create :user_capability, user: admin, capability: capability
    end
  end

  # TODO: user factory you can pass an array of admin types into,
  # to create all of the following (and mixtures) with less repetition...

  factory :blog_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'blogs' )

      list    = category.capabilities.find_by( name: 'list'    )
      add     = category.capabilities.find_by( name: 'add'     )
      edit    = category.capabilities.find_by( name: 'edit'    )
      destroy = category.capabilities.find_by( name: 'destroy' )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy

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

  factory :discussion_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'discussions' )

      hide   = category.capabilities.find_by( name: 'hide'   )
      unhide = category.capabilities.find_by( name: 'unhide' )
      lock   = category.capabilities.find_by( name: 'lock'   )
      unlock = category.capabilities.find_by( name: 'unlock' )

      create :user_capability, user: admin, capability: hide
      create :user_capability, user: admin, capability: unhide
      create :user_capability, user: admin, capability: lock
      create :user_capability, user: admin, capability: unlock

      category = CapabilityCategory.find_by( name: 'comments' )

      hide    = category.capabilities.find_by( name: 'hide'    )
      unhide  = category.capabilities.find_by( name: 'unhide'  )
      lock    = category.capabilities.find_by( name: 'lock'    )
      unlock  = category.capabilities.find_by( name: 'unlock'  )
      destroy = category.capabilities.find_by( name: 'destroy' )

      create :user_capability, user: admin, capability: hide
      create :user_capability, user: admin, capability: unhide
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

  factory :news_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'news_posts' )

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

  factory :page_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'pages' )

      list    = category.capabilities.find_by( name: 'list'    )
      add     = category.capabilities.find_by( name: 'add'     )
      edit    = category.capabilities.find_by( name: 'edit'    )
      destroy = category.capabilities.find_by( name: 'destroy' )

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy

      category = CapabilityCategory.find_by( name: 'page_sections' )

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

  factory :page_template_admin, parent: :page_admin do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'page_templates' )

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

  factory :insert_admin, parent: :admin_user do
    after :create do |admin|
      category = CapabilityCategory.find_by( name: 'inserts' )

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
