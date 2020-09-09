# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Methods to help with paging
module PagingHelper
  def page_number
    return 1 if params[:page].blank?
    return 1 if params[:page].match?( /\D/ )

    params[:page].to_i
  end

  # TODO: configurable per-site default, with per-user/per-action override
  def items_per_page( default: 10 )
    return default if params[:count].blank?
    return default if params[:count].match?( /\D/ )

    params[:count].to_i
  end
end
