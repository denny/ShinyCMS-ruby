# Application mailer base class (NB: user mailer does not inherit from this)
class ApplicationMailer < ActionMailer::Base
  include FeatureFlagsHelper

  before_action :set_view_paths
  before_action :set_site_name

  default from: -> { default_from_address }

  layout 'mailer'

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
