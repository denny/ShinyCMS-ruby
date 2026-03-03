# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller to override or augment Devise user account features
  class Users::RegistrationsController < Devise::RegistrationsController
    include ShinyCMS::WithRecaptcha

    include ShinyCMS::PasswordReportAction

    before_action :check_feature_flags, only: %i[ new create ]

    helper_method :root_path

    def new
      super
    end

    def create
      if pass_recaptcha
        super
      else
        flash[ :show_checkbox_recaptcha ] = true
        flash[ :username ] = params[ :username ]
        flash[ :email    ] = params[ :email    ]
        redirect_to shinycms.new_user_registration_path
      end
    end

    protected

    def after_update_path_for( _resource )
      shinycms.edit_user_registration_path
    end

    private

    def root_path
      # :nocov:
      main_app.root_path
      # :nocov:
    end

    def pass_recaptcha
      return true if no_recaptcha_keys?
      return true if verify_invisible_recaptcha( 'registrations' )

      verify_checkbox_recaptcha || false
    end

    def no_recaptcha_keys?
      recaptcha_checkbox_site_key.blank? &&
        recaptcha_v2_site_key.blank? && recaptcha_v3_site_key.blank?
    end

    def check_feature_flags
      enforce_feature_flags :user_registration
    end
  end
end
