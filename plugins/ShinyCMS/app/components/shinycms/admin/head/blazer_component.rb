# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'blazer/base_helper'

module ShinyCMS
  module Admin
    module Head
      # Component to render Blazer-specific stuff in admin area <head>
      class BlazerComponent < ApplicationComponent
        include Blazer::BaseHelper

        def initialize( root_path: '/' )
          @root_path = root_path
        end
      end
    end
  end
end
