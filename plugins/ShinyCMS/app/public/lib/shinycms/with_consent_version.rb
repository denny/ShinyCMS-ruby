# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Allow other plugins to find consent versions
  module WithConsentVersion
    def consent_version_with_slug( slug )
      ConsentVersion.find_by!( slug: slug )
    end
  end
end
