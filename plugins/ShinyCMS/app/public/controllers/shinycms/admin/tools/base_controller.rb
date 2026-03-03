# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    module Tools
      # For engine controllers to inherit from when embedding them into ShinyCMS admin area
      class BaseController < ActionController::Base
        include Pundit::Authorization

        include ShinyCMS::Admin::AccessControlByIP

        include ShinyCMS::WithFeatureFlags

        before_action :authenticate_user!

        prepend_view_path 'plugins/ShinyCMS/app/views/shinycms'

        layout 'admin/layouts/admin_area'

        helper_method :with_html_editor?

        private

        def with_html_editor?
          false
        end
      end
    end
  end
end
