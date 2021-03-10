# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Mailer for user account related emails (password reset, etc) (uses Devise)
  class UserMailer < ApplicationMailer
    include Devise::Controllers::UrlHelpers

    default from: ->( * ) { default_email }
    default template_path: 'user_mailer'

    # Don't store URLs that might have security tokens in them in email stats data
    track click: false

    def confirmation_instructions( user, token, _args = nil )
      return if not_ok_to_email? user

      set_instance_vars( user, token )

      mail to: @user.email_to, subject: subject_for( :confirmation ) do |format|
        format.html
        format.text
      end
    end

    def email_changed_instructions( user, _args = nil )
      return if not_ok_to_email? user

      set_instance_vars( user )

      mail to: @user.email_to, subject: subject_for( :email_changed ) do |format|
        format.html
        format.text
      end
    end

    def password_changed_instructions( user, _args = nil )
      return if not_ok_to_email? user

      set_instance_vars( user )

      mail to: @user.email_to, subject: subject_for( :password_changed ) do |format|
        format.html
        format.text
      end
    end

    def reset_password_instructions( user, token, _args = nil )
      return if not_ok_to_email? user

      set_instance_vars( user, token )

      mail to: @user.email_to, subject: subject_for( :reset_password ) do |format|
        format.html
        format.text
      end
    end

    def unlock_instructions( user, token, _args = nil )
      return if not_ok_to_email? user

      set_instance_vars( user, token )

      mail to: @user.email_to, subject: subject_for( :unlock ) do |format|
        format.html
        format.text
      end
    end

    private

    def not_ok_to_email?( user )
      DoNotContact.list_includes? user.email
    end

    def set_instance_vars( user, token = nil )
      @resource = @user = user

      @token = token if token

      true
    end

    def subject_for( mailer_name )
      t( "shinycms.user_mailer.#{mailer_name}_instructions.subject", site_name: site_name )
    end
  end
end
