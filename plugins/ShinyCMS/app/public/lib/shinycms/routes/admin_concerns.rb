# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Route concerns for ShinyCMS admin area

# Usage; put this inside the .draw block in `routes.rb`:
#   extend ShinyCMS::Routes::AdminConcerns

module ShinyCMS
  module Routes
    # Route extension to mix in admin route concerns
    module AdminConcerns
      def self.extended( router )
        router.instance_exec do
          concern :with_paging do
            get '(page/:page)(/items/:items)', action: :index, on: :collection, as: ''
          end

          concern :with_search do
            get :search, action: :search, on: :collection
          end
        end
      end
    end
  end
end
