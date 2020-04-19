# frozen_string_literal: true

# Mailer for Devise-powered user account emails (password reset, etc)
class UserMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  before_action :set_view_paths
  before_action :set_site_name

  default from: ->(*) { default_from_address }
  default template_path: 'user_mailer'

  def confirmation_instructions( user, token )
    @resource = @user = user
    @token = token

    mail(
      to: user.email,
      subject: t( '.subject' )
    ) do |format|
      format.html
      format.text
    end
  end

  def reset_password( user, token )
    @resource = @user = user
    @token = token

    mail(
      to: user.email,
      subject: t( '.subject' )
    ) do |format|
      format.html
      format.text
    end
  end

  def password_changed( user )
    @resource = @user = user

    mail(
      to: user.email,
      subject: t( '.subject' )
    ) do |format|
      format.html
      format.text
    end
  end

  def email_changed( user )
    @resource = @user = user

    mail(
      to: user.email,
      subject: t( '.subject' )
    ) do |format|
      format.html
      format.text
    end
  end

  def unlock_instructions( user, token )
    @resource = @user = user
    @token = token

    mail(
      to: user.email,
      subject: t( '.subject' )
    ) do |format|
      format.html
      format.text
    end
  end

  def self.default_url_options
    { host: ENV[ 'MAILER_HOST' ] }
  end

  private

  def default_from_address
    ENV[ 'MAILER_SENDER' ]
  end

  def set_site_name
    @site_name = I18n.t( 'site_name' )
  end

  def set_view_paths
    # Add the default templates directory to the top of view_paths
    prepend_view_path 'app/views/shinycms'
    # Apply the configured theme, if any, by adding it above the defaults
    prepend_view_path Theme.current.view_path if Theme.current
  end
end
