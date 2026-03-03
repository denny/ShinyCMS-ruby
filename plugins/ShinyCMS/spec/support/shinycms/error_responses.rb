# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Allow rspec to test code that is meant to throw an error (e.g. 500 error handler)
  # Taken from: https://eliotsykes.com/2017/03/08/realistic-error-responses/
  module ErrorResponses
    def disable_detailed_exceptions
      env_config = Rails.application.env_config
      original_show_exceptions = env_config[ 'action_dispatch.show_exceptions' ]
      original_show_detailed_exceptions = env_config[ 'action_dispatch.show_detailed_exceptions' ]
      env_config[ 'action_dispatch.show_exceptions'] = :all
      env_config[ 'action_dispatch.show_detailed_exceptions' ] = false
      yield
    ensure
      env_config[ 'action_dispatch.show_exceptions' ] = original_show_exceptions
      env_config[ 'action_dispatch.show_detailed_exceptions' ] = original_show_detailed_exceptions
    end
  end
end
