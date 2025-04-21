# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # User account unlock controller; almost entirely handled by Devise
  class Users::UnlocksController < Devise::ConfirmationsController
    before_action :check_feature_flags

    private

    def check_feature_flags
      enforce_feature_flags :user_login
    end
  end
end
