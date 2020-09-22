# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Base class for Mailers
class ApplicationMailer < ActionMailer::Base
  include FeatureFlagsHelper
  include ShinyMailerHelper

  add_template_helper ShinyMailerHelper

  before_action :set_view_paths

  default from: -> { default_email }

  track open: -> { track_opens? }, click: -> { track_clicks? }

  layout 'mailer'

  private

  def notified_user( email_address, name = nil )
    User.find_by( email: email_address ) ||
      EmailRecipient.find_by( email: email_address ) ||
      EmailRecipient.create!( email: email_address, name: name )
  end

  def set_view_paths
    add_view_paths
  end
end
