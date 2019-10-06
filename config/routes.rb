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
    get 'pages', to: 'pages#index'
    resources :pages, path: 'page', only: %i[ new create edit update delete ]

    namespace :pages do
      # Page sections
      get 'sections', to: 'sections#index'
      resources :sections,
                path: 'section', only: %i[ new create edit update delete ]

      # Page templates
      get 'templates', to: 'templates#index'
      resources :templates,
                path: 'template', only: %i[ new create edit update delete ]
    end

    # Site settings
    get  'settings',           to: 'settings#index'
    post 'settings',           to: 'settings#update'
    post 'setting/create',     to: 'settings#create'
    get  'setting/delete/:id', to: 'settings#delete', as: :setting
  end
end
