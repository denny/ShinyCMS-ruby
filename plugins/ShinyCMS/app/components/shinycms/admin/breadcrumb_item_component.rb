# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Component to render a link in the admin area breadcrumbs
    class BreadcrumbItemComponent < ApplicationComponent
      def initialize( text:, path: )
        @text = text
        @path = path
      end
    end
  end
end
