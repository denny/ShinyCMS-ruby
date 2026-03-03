# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Helper method for admin controllers handling HTML5 date and time inputs
    module WithDateTimeInputs
      extend ActiveSupport::Concern

      included do
        def combine_date_and_time_params( params_hash, date_input_name )
          date_string = params_hash[ date_input_name ]
          time_string = params_hash.delete( "#{date_input_name}_time" )

          params_hash[ date_input_name.to_sym ] = "#{date_string} #{time_string}".strip
          params_hash
        end
      end
    end
  end
end
