# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Methods to help with paging
module ShinyPagingHelper
  include Pagy::Frontend
  include Pagy::Backend

  def items_per_page
    items = params[:items].presence || params[:count].presence || params[:per].presence

    return default_items_per_page if items.blank?
    return default_items_per_page if items.match?( /\D/ )

    items.to_i
  end
end
