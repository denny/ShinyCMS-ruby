# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module Devise
  # Rails inflection is made of fail
  class FailureApp
    def shinycms
      shiny_cms
    end
  end
end
