# Rails routing guide: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  scope format: false do
    # ========== ( Main site ) ==========
    root to: 'pages#index'

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

    get  'discussions',            to: 'discussions#index', as: :discussions
    get  'discussion/:id',         to: 'discussions#show',  as: :discussion
    post 'discussion/:id',         to: 'discussions#add_comment'
    get  'discussion/:id/:number', to: 'discussions#show_thread', as: :comment
    post 'discussion/:id/:number', to: 'discussions#add_reply'

    get 'news',                     to: 'news#index', as: :view_news
    get 'news/:year/:month/:slug',  to: 'news#show',  as: :ignore4,
                                    constraints: {
                                      year: %r{\d\d\d\d},
                                      month: %r{\d\d}
                                    }
    get 'news/:year/:month',        to: 'news#month', as: :ignore5,
                                    constraints: {
                                      year: %r{\d\d\d\d},
                                      month: %r{\d\d}
                                    }
    get 'news/:year',               to: 'news#year',  as: :ignore6,
                                    constraints: { year: %r{\d\d\d\d} }

    get 'profile/:username',  to: 'profiles#show',  as: :user_profile,
                              constraints: { username: User::USERNAME_REGEX }
    get 'profile',            to: 'profiles#profile_redirect'
    get 'profiles',           to: 'profiles#index', as: :user_profiles

    get 'site-settings', to: 'site_settings#index'
    put 'site-settings', to: 'site_settings#update'

    get 'tags',       to: 'tags#index', as: :tags
    get 'tags/cloud', to: 'tags#cloud', as: :tag_cloud
    get 'tags/list',  to: 'tags#list',  as: :tag_list
    get 'tag/:tag',   to: 'tags#show',  as: :tag
    get 'tags/:tags', to: 'tags#show',  as: :show_tags

    devise_for  :users,
                path: '',
                controllers: {
                  registrations: 'users/registrations',
                  sessions: 'users/sessions'
                },
                path_names: {
                  sign_in: '/login',
                  sign_out: '/logout',
                  registration: '/account',
                  sign_up: 'register',
                  confirmation: '/account/confirm',
                  password: '/account/password',
                  unlock: '/account/unlock'
                }

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

      get  :news, to: 'news#index'
      post :news, to: 'news#create', as: :create_news_post
      resources :news, as: :news_post, except: EXCEPT

      # Discussion and comment moderation
      scope path: 'discussion' do
        get ':id/hide',   to: 'discussions#hide',   as: :hide_discussion
        get ':id/unhide', to: 'discussions#unhide', as: :unhide_discussion
        get ':id/lock',   to: 'discussions#lock',   as: :lock_discussion
        get ':id/unlock', to: 'discussions#unlock', as: :unlock_discussion

        get    ':id/hide/:number',    to: 'discussions#hide_comment',
                                      as: :hide_comment
        get    ':id/unhide/:number',  to: 'discussions#unhide_comment',
                                      as: :unhide_comment
        get    ':id/lock/:number',    to: 'discussions#lock_comment',
                                      as: :lock_comment
        get    ':id/unlock/:number',  to: 'discussions#unlock_comment',
                                      as: :unlock_comment
        delete ':id/delete/:number',  to: 'discussions#delete_comment',
                                      as: :delete_comment
      end

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
      get 'site-settings', to: 'site_settings#index', as: :admin_site_settings
      put 'site-settings', to: 'site_settings#update'

      # Web stats
      get 'web-stats',               to: 'web_stats#index'
      get 'web-stats/user/:user_id', to: 'web_stats#index', as: :user_web_stats

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
