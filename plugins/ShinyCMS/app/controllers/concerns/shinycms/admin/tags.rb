# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Common methods for admin controllers that handle content WithTags
    module Tags
      def admin_tag_list( resource )
        resource.tag_list.present? ? resource.tag_list&.join( ', ' ) : resource.hidden_tag_list&.join( ', ' )
      end
    end
  end
end
