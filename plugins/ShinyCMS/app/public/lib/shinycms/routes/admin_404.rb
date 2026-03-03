# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Protect the /admin namespace from fishing expeditions
#
# This route will intercept any URL beginning with /admin that hasn't already
# been matched by another route; it must be the last /admin route defined

# Usage; put this inside the .draw block in `routes.rb`:
#   extend ShinyCMS::Routes::Admin404

module ShinyCMS
  module Routes
    # Route extension that handles non-existent /admin URLs
    module Admin404
      def self.extended( router )
        router.instance_exec do
          match '/admin/*path', to:  'shinycms/admin/root#not_found',
                                as:  :admin_not_found,
                                via: %i[ get post put patch delete ]
        end
      end
    end
  end
end
