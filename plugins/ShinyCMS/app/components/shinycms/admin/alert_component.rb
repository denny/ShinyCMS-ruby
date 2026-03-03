# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Component to render an alert in the admin area
    class AlertComponent < ApplicationComponent
      def initialize( message:, style: )
        @message = message
        @style   = map_rails_to_bootstrap( style )
      end

      def map_rails_to_bootstrap( style )
        return 'alert-success' if style == 'notice'
        return 'alert-danger'  if style == 'alert'

        style
      end
    end
  end
end
