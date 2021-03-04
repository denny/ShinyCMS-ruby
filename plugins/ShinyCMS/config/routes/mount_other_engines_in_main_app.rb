# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes file partial to mount engines from other gems used by ShinyCMS,
# that currently need to be mounted in the main_app routes file.

# See ShinyHostApp config/routes.rb for example usage

# AhoyEmail provides email tracking features
mount AhoyEmail::Engine, at: '/ahoy'

# Blazer provides charts and dashboards in the ShinyCMS admin area
mount Blazer::Engine, at: '/admin/tools/blazer' if defined? Blazer

# REP provides previews of site-generated emails in the ShinyCMS admin area
mount RailsEmailPreview::Engine, at: '/admin/tools/rails-email-preview'
