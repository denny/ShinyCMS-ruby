# frozen_string_literal: true

# Rails routing guide: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  scope format: false do
    ########################################
    # Main site

    root to: 'pages#index'

    if Rails.application.config.multiple_blogs_mode
      # :nocov:
      get 'blogs',                              to: 'blogs#index',
                                                as: :view_blogs
      get 'blog/:blog_slug',                    to: 'blogs#recent',
                                                as: :view_blog
      get 'blog/:blog_slug/:year/:month/:slug', to: 'blogs#show',  as: :view_blog_post
      get 'blog/:blog_slug/:year/:month',       to: 'blogs#month', as: :view_blog_month
      get 'blog/:blog_slug/:year',              to: 'blogs#year',  as: :view_blog_year
      # :nocov:
    else
      get 'blog',                     to: 'blogs#recent', as: :view_blog
      get 'blog/:year/:month/:slug',  to: 'blogs#show',   as: :view_blog_post,
                                      constraints: {
                                        year: %r{\d\d\d\d},
                                        month: %r{\d\d}
                                      }
      get 'blog/:year/:month',        to: 'blogs#month',  as: :view_blog_month,
                                      constraints: {
                                        year: %r{\d\d\d\d},
                                        month: %r{\d\d}
                                      }
      get 'blog/:year',               to: 'blogs#year',   as: :view_blog_year,
                                      constraints: { year: %r{\d\d\d\d} }
    end

    get  'discussions',            to: 'discussions#index', as: :discussions
    get  'discussion/:id',         to: 'discussions#show',  as: :discussion
    post 'discussion/:id',         to: 'discussions#add_comment'
    get  'discussion/:id/:number', to: 'discussions#show_thread', as: :comment
    post 'discussion/:id/:number', to: 'discussions#add_reply'

    get 'news',                     to: 'news#index', as: :view_news
    get 'news/:year/:month/:slug',  to: 'news#show',  as: :view_news_post,
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

    post   'vote/:type/:id/:flag', to: 'votes#create',  as: :create_vote
    delete 'vote/:type/:id',       to: 'votes#destroy', as: :destroy_vote

    ########################################
    # Admin area

    get :admin, to: 'admin#index'

    scope path: 'admin', module: 'admin' do
      EXCEPT = %w[ index show create ].freeze

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
      get :comments, to: 'comments#index'
      put :comments, to: 'comments#update'
      scope path: 'comment' do
        put    ':id/show',    to: 'comments#show',          as: :show_comment
        put    ':id/hide',    to: 'comments#hide',          as: :hide_comment
        put    ':id/lock',    to: 'comments#lock',          as: :lock_comment
        put    ':id/unlock',  to: 'comments#unlock',        as: :unlock_comment
        put    ':id/is-spam', to: 'comments#mark_as_spam',  as: :spam_comment
        delete ':id/delete',  to: 'comments#destroy',       as: :destroy_comment
      end
      scope path: 'discussion' do
        put ':id/show',   to: 'discussions#show',   as: :show_discussion
        put ':id/hide',   to: 'discussions#hide',   as: :hide_discussion
        put ':id/lock',   to: 'discussions#lock',   as: :lock_discussion
        put ':id/unlock', to: 'discussions#unlock', as: :unlock_discussion
      end

      # Feature Flags
      get 'feature-flags', to: 'feature_flags#index'
      put 'feature-flags', to: 'feature_flags#update'

      # Inserts
      get    :inserts,     to: 'inserts#index',   as: :inserts
      put    :inserts,     to: 'inserts#update'
      post   :insert,      to: 'inserts#create',  as: :create_insert
      delete 'insert/:id', to: 'inserts#destroy', as: :destroy_insert

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

      # Stats
      get 'web-stats',                to: 'web_stats#index'
      get 'web-stats/user/:user_id',  to: 'web_stats#index', as: :user_web_stats
      get 'email-stats',                to: 'email_stats#index'
      get 'email-stats/user/:user_id',  to: 'email_stats#index',
                                        as: :user_email_stats

      # Users
      get  :users, to: 'users#index'
      post :user,  to: 'users#create', as: :create_user
      resources :user, controller: :users, except: EXCEPT
    end

    ########################################
    # Rails engines

    # AhoyEmail provides email tracking features
    mount AhoyEmail::Engine, at: '/ahoy'

    # Blazer provides charts and dashboards in the admin area
    mount Blazer::Engine, at: '/admin/stats'

    # CKEditor provides the WYSIWYG editor used in the admin area
    mount Ckeditor::Engine, at: '/admin/ckeditor'

    # RailsEmailPreview provides previews of site emails in the admin area
    mount RailsEmailPreview::Engine, at: '/admin/email-previews'

    # LetterOpener provides a webmail UI for viewing sent emails (in dev only)
    mount LetterOpenerWeb::Engine, at: '/dev/outbox' if Rails.env.development?

    ########################################
    # ShinyCMS plugins

    # ShinyForms: generic form handlers
    mount ShinyForms::Engine, at: '/' if defined?(ShinyForms)

    ###########################################################################
    # This final catch-all route passes through to the Pages controller.
    # This makes it possible to have pages and sections at the top level
    # e.g. /foo instead of /pages/foo
    get '*path', to: 'pages#show'
  end
end
