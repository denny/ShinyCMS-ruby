# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    module Tools
      # Base class that e.g. engines from gems can inherit from relatively safely
      class BaseController < ActionController::Base
        include Pundit

        include ShinyCMS::Admin::AccessControlByIP

        include ShinyCMS::FeatureFlags

        before_action :authenticate_user!

        prepend_view_path 'plugins/ShinyCMS/app/views/shinycms'

        layout 'admin/layouts/admin_area'
      end
    end
  end
end
