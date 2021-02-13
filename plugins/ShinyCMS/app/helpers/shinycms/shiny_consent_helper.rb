# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper method for retrieving consent versions
  module ShinyConsentHelper
    def consent_version( slug )
      ConsentVersion.find_by( slug: slug )
    end
  end
end