# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Base controller for Rails Email Preview, used by /admin/emails
class Admin::EmailPreviewsController < AdminController
  before_action -> { authorise :email_preview }, only: %i[ index show ]
end
