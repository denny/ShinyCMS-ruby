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
      get  'sections',     to: 'sections#index'
      get  'sections/add', to: 'sections#new'
      post 'sections/add', to: 'sections#create'
      get  'sections/:id', to: 'sections#edit'
      post 'sections/:id', to: 'sections#update'

      # Page templates
      get  'templates',     to: 'templates#index'
      get  'templates/add', to: 'templates#new'
      post 'templates/add', to: 'templates#create'
      get  'templates/:id', to: 'templates#edit'
      post 'templates/:id', to: 'templates#update'
    end
  end
end
