# Rails routing guide: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  scope format: false do
    # ========== ( Main site ) ==========
    root to: 'pages#index'

    # Blogs
    if Rails.application.config.multiple_blogs_mode
      # :nocov:
      get 'blogs',                              to: 'blogs#index',
                                                as: :view_blogs
      get 'blog/:blog_slug',                    to: 'blogs#recent',
                                                as: :view_blog
      get 'blog/:blog_slug/:year/:month/:slug', to: 'blogs#show',  as: :ignore1
      get 'blog/:blog_slug/:year/:month',       to: 'blogs#month', as: :ignore2
      get 'blog/:blog_slug/:year',              to: 'blogs#year',  as: :ignore3
      # :nocov:
    else
      get 'blog',                     to: 'blogs#recent', as: :view_blog
      get 'blog/:year/:month/:slug',  to: 'blogs#show',   as: :ignore1,
                                      constraints: {
                                        year: %r{\d\d\d\d},
                                        month: %r{\d\d}
                                      }
      get 'blog/:year/:month',        to: 'blogs#month',  as: :ignore2,
                                      constraints: {
                                        year: %r{\d\d\d\d},
                                        month: %r{\d\d}
                                      }
      get 'blog/:year',               to: 'blogs#year',   as: :ignore3,
                                      constraints: { year: %r{\d\d\d\d} }
    end

    get 'tags',      to: 'tags#index', as: :tags
    get 'tags/:tag', to: 'tags#show',  as: :tag

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
    get 'user/:username',  to: 'users#show',  as: :user_profile,
                           constraints: { username: User::USERNAME_REGEX }
    get 'user',            to: 'users#index', as: :user_redirect
    get 'users',           to: 'users#index', as: :users_redirect

    # ========== ( Admin area ) ==========
    get 'admin', to: 'admin#index'

    # CKEditor (WYSIWYG editor used on various admin pages)
    mount Ckeditor::Engine => '/admin/ckeditor'

    EXCEPT = %w[ index show create ].freeze

    scope path: 'admin', module: 'admin' do
      # Blogs
      get  :blogs, to: 'blogs#index'
      post :blog,  to: 'blogs#create', as: :create_blog

      resources :blog, controller: :blogs, as: :blog, except: EXCEPT do
        get :posts, to: 'blog/posts#index'
        resources :post, controller: 'blog/posts', except: EXCEPT
      end
      post 'blog/:id/post', to: 'blog/posts#create', as: :create_blog_post

      # Feature Flags
      get 'feature-flags', to: 'feature_flags#index'
      put 'feature-flags', to: 'feature_flags#update'

      # Inserts
      get    'inserts',    to: 'inserts#index'
      put    'inserts',    to: 'inserts#update'
      post   'insert',     to: 'inserts#create',  as: :create_insert
      delete 'insert/:id', to: 'inserts#destroy', as: :insert

      # Pages
      get  :pages, to: 'pages#index'
      post :page,  to: 'pages#create', as: :create_page
      resources :page, controller: :pages, except: EXCEPT

      scope path: :pages, module: :pages, as: :page do
        get :sections,  to: 'sections#index'
        resources :section,  controller: :sections, except: EXCEPT
        get :templates, to: 'templates#index'
        resources :template, controller: :templates, except: EXCEPT
      end
      post 'pages/section',   to: 'pages/sections#create',
                              as: :create_page_section
      post 'pages/template',  to: 'pages/templates#create',
                              as: :create_page_template

      # Site settings
      get    'settings',    to: 'settings#index'
      put    'settings',    to: 'settings#update'
      post   'setting',     to: 'settings#create'
      delete 'setting/:id', to: 'settings#destroy', as: :delete_setting

      # Users
      get  :users, to: 'users#index'
      post :user,  to: 'users#create', as: :create_user
      resources :user, controller: :users, except: EXCEPT
    end

    # The Ultimate Catch-All Route! Passes through to page handler,
    # so that we can have top-level pages - /foo instead of /pages/foo
    get '*path', to: 'pages#show'
  end
end
