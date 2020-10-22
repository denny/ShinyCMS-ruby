# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Methods to help with paging
module ShinyPagingHelper
  def page_number
    return 1 if params[:page].blank?
    return 1 if params[:page].match?( /\D/ )

    params[:page].to_i
  end

  def items_per_page
    count = params[:count].presence || params[:size].presence || params[:per].presence

    return default_items_per_page if count.blank?
    return default_items_per_page if count.match?( /\D/ )

    count.to_i
  end
end
