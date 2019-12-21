# Rails routing guide: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  scope format: false do
    # ========== ( Main site ) ==========
    root to: 'pages#index'

    # Pages
    get 'pages',       to: 'pages#index'
    get 'pages/*path', to: 'pages#show'

    # Blogs
    if Rails.application.config.multiple_blogs_mode
      get 'blogs',                               to: 'blogs#index'
      get 'blog/:blog_slug',                     to: 'blogs#recent'
      get 'blog/:blog_slug/:year/:month/:slug',  to: 'blogs#show'
      get 'blog/:blog_slug/:year/:month',        to: 'blogs#month'
      get 'blog/:blog_slug/:year',               to: 'blogs#year'
    else
      get 'blog',                     to: 'blogs#recent', as: :blog
      get 'blog/:year/:month/:slug',  to: 'blogs#show',   as: :blog_post
      get 'blog/:year/:month',        to: 'blogs#month',  as: :blog_month
      get 'blog/:year',               to: 'blogs#year',   as: :blog_year
    end

    # Users
    devise_for  :users,
                path: '',
                controllers: {
                  registrations: 'users/registrations',
                  sessions: 'users/sessions'
                },
                path_names: {
                  sign_in: '/login',
                  sign_out: '/logout',
                  registration: '/user/account',
                  sign_up: 'register',
                  confirmation: '/user/account/confirm',
                  password: '/user/account/password',
                  unlock: '/user/account/unlock'
                }
    get 'user',            to: 'users#index'
    get 'users',           to: 'users#index'
    get 'user/:username',  to: 'users#show',
                           as: :user_profile,
                           constraints: { username: User::USERNAME_REGEX }

    # ========== ( Admin area ) ==========
    get 'admin', to: 'admin#index'

    # CKEditor (WYSIWYG editor used on various admin pages)
    mount Ckeditor::Engine => '/admin/ckeditor'

    namespace :admin do
      # Pages
      get    'pages',          to: 'pages#index'
      get    'page/new',       to: 'pages#new'
      post   'page/new',       to: 'pages#create'
      get    'page/:id',       to: 'pages#edit',       as: :page
      post   'page/:id',       to: 'pages#update'
      delete 'page/:id',       to: 'pages#delete',     as: :page_delete

      namespace :pages do
        # Page sections
        get    'sections',     to: 'sections#index'
        get    'section/new',  to: 'sections#new'
        post   'section/new',  to: 'sections#create'
        get    'section/:id',  to: 'sections#edit',    as: :section
        post   'section/:id',  to: 'sections#update'
        delete 'section/:id',  to: 'sections#delete',  as: :section_delete

        # Page templates
        get    'templates',    to: 'templates#index'
        get    'template/new', to: 'templates#new'
        post   'template/new', to: 'templates#create'
        get    'template/:id', to: 'templates#edit',   as: :template
        post   'template/:id', to: 'templates#update'
        delete 'template/:id', to: 'templates#delete', as: :template_delete
      end

      # Blogs
      resources :blogs
      namespace :blog do
        resources :posts
      end

      # Shared Content
      get    'shared-content',            to: 'shared_content#index',
                                          as: :shared_content
      post   'shared-content',            to: 'shared_content#update'
      post   'shared-content/create',     to: 'shared_content#create',
                                          as: :shared_content_create
      delete 'shared-content/delete/:id', to: 'shared_content#delete',
                                          as: :shared_content_delete

      # Site settings
      get    'settings',           to: 'settings#index'
      post   'settings',           to: 'settings#update'
      post   'setting/create',     to: 'settings#create', as: :setting_create
      delete 'setting/delete/:id', to: 'settings#delete', as: :setting_delete

      # Users
      get    'users',    to: 'users#index'
      get    'user/new', to: 'users#new'
      post   'user/new', to: 'users#create'
      get    'user/:id', to: 'users#edit',   as: :user
      post   'user/:id', to: 'users#update'
      delete 'user/:id', to: 'users#delete', as: :user_delete
    end

    # The Ultimate Catch-All Route - passes through to page handler
    get '*path', to: 'pages#show'
  end
end
