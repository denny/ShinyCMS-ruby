# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Protect the /admin namespace from fishing expeditions
# See ShinyHostApp config/routes.rb for how to use this file

# This route will match anything in the /admin URL namespace that hasn't already
# been matched by another route; it must be defined after every other /admin URL

match '/admin/*path', to: 'shinycms/admin/root#not_found', as: :admin_not_found, via: %i[ get post put patch delete ]
