# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/emails_controller.rb
# Purpose:   Base controller for Rails Email Preview, used by /admin/emails
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::EmailsController < AdminController
  # TODO: FIXME: Suboptimal security here.
  skip_after_action :verify_authorized
end
