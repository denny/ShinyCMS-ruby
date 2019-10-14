# Rails routing guide: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  devise_for :users
  # ========== ( Main site ) ==========
  root to: 'pages#index'

  # Pages
  get 'pages',        to: 'pages#index'
  get 'pages/:slug',  to: 'pages#show_top_level'
  get 'pages/*slugs', to: 'pages#show_in_section'

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
end
