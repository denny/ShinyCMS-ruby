# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Base controller for Rails Email Preview, used by /admin/emails
class Admin::EmailPreviewsController < ShinyCMS::AdminController
  before_action -> { authorize :mailer_preview }, only: %i[ index show ]
end
