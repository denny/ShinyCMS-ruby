# Application Mailer
class ApplicationMailer < ActionMailer::Base
  include FeatureFlagsHelper

  before_action :set_view_paths

  default from: ENV[ 'MAILER_SENDER' ]

  layout 'mailer'

  private

  def set_view_paths
    # Add the default templates directory to the top of view_paths
    prepend_view_path 'app/views/shinycms'
    # Apply the configured theme, if any, by adding it above the defaults
    prepend_view_path Theme.current.view_path if Theme.current
  end
end
