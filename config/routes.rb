# Rails routing guide: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  # ========== ( Main site ) ==========
  root to: 'pages#index'

  # Pages
  get 'pages',       to: 'pages#index'
  get 'pages/*path', to: 'pages#show'

  # Users
  get 'user',  to: 'user#index', as: :user_index
  get 'users', to: 'user#index'
  devise_scope :user do
    get  '/login',         to: 'devise/sessions#new',      as: :user_login
    get  '/logout',        to: 'devise/sessions#destroy',  as: :user_logout
    get  '/user/register', to: 'devise/registrations#new', as: :user_register
    post '/user/register', to: 'devise/registrations#create'
  end
  devise_for  :users,
              singular: 'user',
              path: 'user',
              path_names: {
                sign_in: 'login',
                sign_out: 'logout'
              }
  get 'user/:username', to: 'user#show', as: :user_profile,
                        constraints: { username: User::USERNAME_REGEX }

  # ========== ( Admin area ) ==========
  get 'admin', to: 'admin#index'

  namespace :admin do
    # Pages
    get  'pages',    to: 'pages#index'
    get  'page/new', to: 'pages#new'
    post 'page/new', to: 'pages#create'
    get  'page/:id', to: 'pages#edit', as: :page
    post 'page/:id', to: 'pages#update'

    namespace :pages do
      # Page sections
      get  'sections',    to: 'sections#index'
      get  'section/new', to: 'sections#new'
      post 'section/new', to: 'sections#create'
      get  'section/:id', to: 'sections#edit', as: :section
      post 'section/:id', to: 'sections#update'

      # Page templates
      get  'templates',    to: 'templates#index'
      get  'template/new', to: 'templates#new'
      post 'template/new', to: 'templates#create'
      get  'template/:id', to: 'templates#edit', as: :template
      post 'template/:id', to: 'templates#update'
    end

    # Site settings
    get    'settings',           to: 'settings#index'
    post   'settings',           to: 'settings#update'
    post   'setting/create',     to: 'settings#create', as: :setting_create
    delete 'setting/delete/:id', to: 'settings#delete', as: :setting_delete
  end

  # The Ultimate Catch-All Route - passes through to page handler
  get '*path', to: 'pages#show'
end
