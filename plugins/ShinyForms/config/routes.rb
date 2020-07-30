# frozen_string_literal: true

ShinyForms::Engine.routes.draw do
  post 'form/:slug', to: 'forms#process', as: :form

  scope path: 'admin', module: 'admin' do
    resources :forms, except: :show
  end
end
