# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # For admin controllers that handle content from models that include HasTags
    module WithTags
      extend ActiveSupport::Concern

      included do
        def admin_tag_list( resource )
          return resource.hidden_tag_list.to_s if resource.hidden?

          resource.tag_list.to_s
        end
      end
    end
  end
end
