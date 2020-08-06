# frozen_string_literal: true

# Base class for Mailers
class ApplicationMailer < ActionMailer::Base
  include FeatureFlagsHelper

  before_action :set_view_paths
  before_action :set_site_name

  track open: -> { track_opens? }, click: -> { track_clicks? }

  default from: -> { default_email }

  layout 'mailer'

  private

  def track_opens?
    Setting.get( :track_opens )&.downcase == 'yes'
  end

  def track_clicks?
    Setting.get( :track_clicks )&.downcase == 'yes'
  end

  def default_email
    Setting.get( :default_email ) || ENV[ 'DEFAULT_EMAIL' ]
  end

  def notified_user( email_address, name = nil )
    User.find_by( email: email_address ) ||
      EmailRecipient.find_by( email: email_address ) ||
      EmailRecipient.create!( email: email_address, name: name )
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
