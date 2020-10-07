# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyForms::Engine.routes.draw do
  scope format: false do
    # Main site
    post 'form/:slug', to: 'forms#process_form', as: :process_form

    # Admin area
    scope path: 'admin', module: 'admin' do
      get 'forms/search', to: 'forms#search'

      resources :forms, except: :show
    end
  end
end
