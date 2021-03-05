# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require_relative '../../../plugins/ShinyCMS/lib/import_routes'

ShinyForms::Engine.routes.draw do
  scope format: false do
    # Main site
    post 'form/:slug', to: 'forms#process_form', as: :process_form

    # Admin area
    scope path: 'admin', module: 'admin' do
      # with_paging and with_search
      import_routes partial: :admin_route_concerns

      resources :forms, except: %i[ index show ], concerns: %i[ with_paging with_search ]
    end
  end
end
