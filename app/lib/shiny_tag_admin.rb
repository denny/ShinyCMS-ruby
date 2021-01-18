# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Methods that any admin controller handling ShinyTags might want
module ShinyTagAdmin
  def admin_tag_list( resource )
    resource.tag_list.present? ? resource.tag_list&.join( ', ' ) : resource.hidden_tag_list&.join( ', ' )
  end
end
