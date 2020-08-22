# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/users/registrations_controller.rb
# Purpose:   Controller to override or augment Devise user account features
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Users::RegistrationsController < Devise::RegistrationsController
  include FeatureFlagsHelper
  include RecaptchaHelper

  before_action :check_feature_flags, only: %i[ new create ]

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
      redirect_to action: :new
    end
  end

  protected

  def after_update_path_for( _resource )
    edit_user_registration_path
  end

  private

  def pass_recaptcha
    return true if no_recaptcha_keys
    return true if verify_invisible_recaptcha( 'registration' )

    verify_checkbox_recaptcha || false
  end

  def no_recaptcha_keys
    recaptcha_checkbox_site_key.blank? &&
      recaptcha_v2_site_key.blank? && recaptcha_v3_site_key.blank?
  end

  def check_feature_flags
    enforce_feature_flags :user_registration
  end
end
