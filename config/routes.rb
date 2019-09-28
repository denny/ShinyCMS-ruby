# Rails routing guide: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  # Homepage
  root to: 'home#index'

  # Pages
  get 'pages', to: 'pages#index'

  # Admin area
  get 'admin', to: 'admin#index'

  namespace :admin do
    get  'pages',     to: 'pages#index'
    get  'pages/add', to: 'pages#new'
    post 'pages',     to: 'pages#create'
    get  'pages/:id', to: 'pages#edit'
    post 'pages/:id', to: 'pages#update'

    namespace :pages do
      get  'sections',     to: 'sections#index'
      get  'sections/add', to: 'sections#new'
      post 'sections',     to: 'sections#create'
      get  'sections/:id', to: 'sections#edit'
      post 'sections/:id', to: 'sections#update'

      get  'templates',     to: 'templates#index'
      get  'templates/add', to: 'templates#new'
      post 'templates',     to: 'templates#create'
      get  'templates/:id', to: 'templates#edit'
      post 'templates/:id', to: 'templates#update'
    end
  end
end
