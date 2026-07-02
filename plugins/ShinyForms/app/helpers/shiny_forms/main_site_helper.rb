# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Helper method for finding form handlers - part of ShinyForms plugin for ShinyCMS
  module MainSiteHelper
    def find_form_by_slug( slug )
      ShinyForms::Form.find_by( slug: slug )
    end
  end
end
