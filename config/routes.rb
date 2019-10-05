# Rails routing guide: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
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
    get  'page/add', to: 'pages#new'
    post 'page/add', to: 'pages#create'
    get  'page/:id', to: 'pages#edit'
    post 'page/:id', to: 'pages#update'

    namespace :pages do
      # Page sections
      get  'sections',    to: 'sections#index'
      get  'section/add', to: 'sections#new'
      post 'section/add', to: 'sections#create'
      get  'section/:id', to: 'sections#edit'
      post 'section/:id', to: 'sections#update'

      # Page templates
      get  'templates',    to: 'templates#index'
      get  'template/add', to: 'templates#new'
      post 'template/add', to: 'templates#create'
      get  'template/:id', to: 'templates#edit'
      post 'template/:id', to: 'templates#update'
    end

    # Site settings
    get  'settings',           to: 'settings#index'
    post 'settings',           to: 'settings#update'
    post 'setting/create',     to: 'settings#create'
    get  'setting/delete/:id', to: 'settings#delete', as: :setting
  end
end
