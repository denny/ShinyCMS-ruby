# frozen_string_literal: true

# ShinyInserts plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

ShinyInserts::Engine.routes.draw do
  scope format: false do
    # Admin area
    scope path: 'admin', module: 'admin' do
      get    :inserts,     to: 'inserts#index',   as: :inserts
      put    :inserts,     to: 'inserts#update'
      post   :insert,      to: 'inserts#create',  as: :create_insert
      delete 'insert/:id', to: 'inserts#destroy', as: :destroy_insert
    end
  end
end
