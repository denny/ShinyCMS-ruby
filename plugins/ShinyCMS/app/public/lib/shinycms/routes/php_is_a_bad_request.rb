# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Give requests for .php URLs the love and respect they deserve

# Usage; put this inside the .draw block in `routes.rb`:
#   extend ShinyCMS::Routes::PHPIsABadRequest

module ShinyCMS
  module Routes
    # Route extension that returns 400 (bad request) for all URLs ending in .php
    module PHPIsABadRequest
      def self.extended( router )
        router.instance_exec do
          match '*anything_ending_in.php', to: 'shinycms/errors#bad_request', as: :php_is_a_bad_request, via: :all
        end
      end
    end
  end
end
