# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Route for the root_path, if you want ShinyPages to handle it
# See ShinyHostApp config/routes.rb for how to use this file

scope format: false do
  root to: 'shiny_pages/pages#index'
end
