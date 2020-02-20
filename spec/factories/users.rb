FactoryBot.define do
  factory :user do
    email        { Faker::Internet.email( name: username ) }
    username     { Faker::Internet.unique.username }
    password     { Faker::Internet.password        }
    confirmed_at { Time.current                    }
  end

  factory :admin_user, parent: :user do
    after :create do |admin|
      general_category = create :capability_category, name: 'general'
      view = create :capability, name: 'view_admin_area', category: general_category
      create :user_capability, user: admin, capability: view
    end
  end

  # TODO: user factory you can pass an array of admin types into,
  # to create all of the following (and mixtures) with less repetition...

  factory :blog_admin, parent: :admin_user do
    after :create do |admin|
      category = create :capability_category, name: 'blogs'

      list    = create :capability, name: 'list',    category: category
      add     = create :capability, name: 'add',     category: category
      edit    = create :capability, name: 'edit',    category: category
      destroy = create :capability, name: 'destroy', category: category

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy

      category = create :capability_category, name: 'blog_posts'

      list    = create :capability, name: 'list',    category: category
      add     = create :capability, name: 'add',     category: category
      edit    = create :capability, name: 'edit',    category: category
      destroy = create :capability, name: 'destroy', category: category
      # author  = create :capability, name: 'change_author', category: category

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy
      # create :user_capability, user: admin, capability: author
    end
  end

  factory :comment_admin, parent: :admin_user do
    after :create do |admin|
      category = create :capability_category, name: 'comments'

      hide   = create :capability, name: 'hide',   category: category
      lock   = create :capability, name: 'lock',   category: category
      delete = create :capability, name: 'delete', category: category

      create :user_capability, user: admin, capability: hide
      create :user_capability, user: admin, capability: lock
      create :user_capability, user: admin, capability: delete

      category = create :capability_category, name: 'discussions'

      hide = create :capability, name: 'hide', category: category
      lock = create :capability, name: 'lock', category: category

      create :user_capability, user: admin, capability: hide
      create :user_capability, user: admin, capability: lock
    end
  end

  factory :feature_flags_admin, parent: :admin_user do
    after :create do |admin|
      category = create :capability_category, name: 'feature_flags'

      list    = create :capability, name: 'list',    category: category
      edit    = create :capability, name: 'edit',    category: category

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: edit
    end
  end

  factory :page_admin, parent: :admin_user do
    after :create do |admin|
      category = create :capability_category, name: 'pages'

      list    = create :capability, name: 'list',    category: category
      add     = create :capability, name: 'add',     category: category
      edit    = create :capability, name: 'edit',    category: category
      destroy = create :capability, name: 'destroy', category: category

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy

      category = create :capability_category, name: 'page_sections'

      list    = create :capability, name: 'list',    category: category
      add     = create :capability, name: 'add',     category: category
      edit    = create :capability, name: 'edit',    category: category
      destroy = create :capability, name: 'destroy', category: category

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy
    end
  end

  factory :page_template_admin, parent: :page_admin do
    after :create do |admin|
      category = create :capability_category, name: 'page_templates'

      list    = create :capability, name: 'list',    category: category
      add     = create :capability, name: 'add',     category: category
      edit    = create :capability, name: 'edit',    category: category
      destroy = create :capability, name: 'destroy', category: category

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy
    end
  end

  factory :insert_admin, parent: :admin_user do
    after :create do |admin|
      category = create :capability_category, name: 'inserts'

      list    = create :capability, name: 'list',    category: category
      add     = create :capability, name: 'add',     category: category
      edit    = create :capability, name: 'edit',    category: category
      destroy = create :capability, name: 'destroy', category: category

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy
    end
  end

  factory :settings_admin, parent: :admin_user do
    after :create do |admin|
      category = create :capability_category, name: 'settings'

      list    = create :capability, name: 'list',    category: category
      edit    = create :capability, name: 'edit',    category: category

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: edit
    end
  end

  factory :user_admin, parent: :admin_user do
    after :create do |admin|
      category = create :capability_category, name: 'users'

      list    = create :capability, name: 'list',             category: category
      add     = create :capability, name: 'add',              category: category
      edit    = create :capability, name: 'edit',             category: category
      destroy = create :capability, name: 'destroy',          category: category
      notes   = create :capability, name: 'view_admin_notes', category: category

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy
      create :user_capability, user: admin, capability: notes
    end
  end

  factory :super_admin, parent: :user_admin do
    after :create do |admin|
      category = create :capability_category, name: 'admin_users'

      list    = create :capability, name: 'list',    category: category
      add     = create :capability, name: 'add',     category: category
      edit    = create :capability, name: 'edit',    category: category
      destroy = create :capability, name: 'destroy', category: category

      create :user_capability, user: admin, capability: list
      create :user_capability, user: admin, capability: add
      create :user_capability, user: admin, capability: edit
      create :user_capability, user: admin, capability: destroy
    end
  end
end
