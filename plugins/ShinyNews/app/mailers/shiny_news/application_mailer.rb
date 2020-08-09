# frozen_string_literal: true

# ============================================================================
# Project:   ShinyNews plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyNews/app/models/shiny_news/application_mailer.rb
# Purpose:   Base class for mailers
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyNews
  # Base class for mailers
  class ApplicationMailer < ActionMailer::Base
    default from: Setting.get( :default_mail )

    layout 'mailer'
  end
end
