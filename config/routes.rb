# Rails routing guide: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  scope format: false do
    # ========== ( Main site ) ==========
    root to: 'pages#index'

    # Blogs
    if Rails.application.config.multiple_blogs_mode
      # :nocov:
      get 'blogs',                               to: 'blogs#index'
      get 'blog/:blog_slug',                     to: 'blogs#recent'
      get 'blog/:blog_slug/:year/:month/:slug',  to: 'blogs#show'
      get 'blog/:blog_slug/:year/:month',        to: 'blogs#month'
      get 'blog/:blog_slug/:year',               to: 'blogs#year'
      # :nocov:
    else
      get 'blog',                     to: 'blogs#recent', as: :blog
      get 'blog/:year/:month/:slug',  to: 'blogs#show',   as: :blog_post,
                                      constraints: {
                                        year: %r{\d\d\d\d},
                                        month: %r{\d\d}
                                      }
      get 'blog/:year/:month',        to: 'blogs#month',  as: :blog_month,
                                      constraints: {
                                        year: %r{\d\d\d\d},
                                        month: %r{\d\d}
                                      }
      get 'blog/:year',               to: 'blogs#year',   as: :blog_year,
                                      constraints: { year: %r{\d\d\d\d} }
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
    get 'users',           to: 'users#index', as: :main_site_users_redirect
    get 'user',            to: 'users#index', as: :main_site_user_redirect
    get 'user/:username',  to: 'users#show',  as: :user_profile,
                           constraints: { username: User::USERNAME_REGEX }

    # ========== ( Admin area ) ==========
    get 'admin', to: 'admin#index'

    # CKEditor (WYSIWYG editor used on various admin pages)
    mount Ckeditor::Engine => '/admin/ckeditor'

    scope path: 'admin', module: 'admin' do
      # Blogs
      get  :blogs, to: 'blogs#index'
      post :blog,  to: 'blogs#create'

      resources :blog, controller: :blogs, except: %w[ index show create ] do
        get  :posts, to: 'posts#index'
        post :post,  to: 'posts#create'
        resources :post, controller: :posts, except: %w[ index show create ]
      end

      # Pages
      get  :pages, to: 'pages#index'
      post :page,  to: 'pages#create'
      resources :page, controller: :pages, except: %w[ index show create ]

      scope path: :pages, module: :pages, as: :page do
        post :section,   to: 'sections#create'
        resources :section,  controller: :sections,
                             except: %w[ index show create ]
        get  :templates, to: 'templates#index'
        post :template,  to: 'templates#create'
        resources :template, controller: :templates,
                             except: %w[ index show create ]
      end

      # Shared Content
      get    'shared-content',        to: 'shared_content#index',
                                      as: :shared_content
      post   'shared-content',        to: 'shared_content#update'
      post   'shared-content/create', to: 'shared_content#create',
                                      as: :shared_content_create
      delete 'shared-content/:id',    to: 'shared_content#delete',
                                      as: :shared_content_delete

      # Site settings
      get    'settings',           to: 'settings#index'
      post   'settings',           to: 'settings#update'
      post   'setting/create',     to: 'settings#create', as: :setting_create
      delete 'setting/delete/:id', to: 'settings#delete', as: :setting_delete

      # Users
      get  :users, to: 'users#index'
      post :user,  to: 'users#create'
      resources :user, controller: :users, except: %w[ index show create ]
    end

    # The Ultimate Catch-All Route! Passes through to page handler,
    # so that we can have top-level pages - /foo instead of /pages/foo
    get '*path', to: 'pages#show'
  end
end
