# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Base mailer class - ShinyForms plugin for ShinyCMS
  class ApplicationMailer < ActionMailer::Base
    include ShinyMailerHelper

    add_template_helper ShinyMailerHelper

    before_action :set_view_paths

    track open: false, click: false

    default from: -> { default_email }

    layout 'mailer'

    private

    def set_view_paths
      add_view_paths( 'plugins/ShinyForms/app/views' )
    end
  end
end
