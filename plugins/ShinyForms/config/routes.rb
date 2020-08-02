# frozen_string_literal: true

ShinyForms::Engine.routes.draw do
  scope format: false do
    post 'form/:slug', to: 'forms#process', as: :process_form

    scope path: 'admin', module: 'admin' do
      resources :forms, except: :show
    end
  end
end
