# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Smarter error pages
  class ErrorsController < MainController
    def not_found
      render status: :not_found
    end

    def internal_server_error
      render status: :internal_server_error
    end

    def test500
      raise StandardError, 'Boom.'
    end
  end
end
