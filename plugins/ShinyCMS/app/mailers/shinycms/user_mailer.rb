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
      @resource = @user = user
      @token = token

      return if DoNotContact.list_includes? @user.email # TODO: make this happen without explicit call

      mail to: user.email_to, subject: subject_for( :confirmation ) do |format|
        format.html
        format.text
      end
    end

    def reset_password_instructions( user, token, _args = nil )
      @resource = @user = user
      @token = token

      return if DoNotContact.list_includes? @user.email # TODO: make this happen without explicit call

      mail to: user.email_to, subject: subject_for( :reset_password ) do |format|
        format.html
        format.text
      end
    end

    def password_changed_instructions( user, _args = nil )
      @resource = @user = user

      return if DoNotContact.list_includes? @user.email # TODO: make this happen without explicit call

      mail to: user.email_to, subject: subject_for( :password_changed ) do |format|
        format.html
        format.text
      end
    end

    def email_changed_instructions( user, _args = nil )
      @resource = @user = user

      return if DoNotContact.list_includes? @user.email # TODO: make this happen without explicit call

      mail to: user.email_to, subject: subject_for( :email_changed ) do |format|
        format.html
        format.text
      end
    end

    def unlock_instructions( user, token, _args = nil )
      @resource = @user = user
      @token = token

      return if DoNotContact.list_includes? @user.email # TODO: make this happen without explicit call

      mail to: user.email_to, subject: subject_for( :unlock ) do |format|
        format.html
        format.text
      end
    end

    def subject_for( mailer_name )
      t( "shinycms.user_mailer.#{mailer_name}_instructions.subject", site_name: site_name )
    end
  end
end
