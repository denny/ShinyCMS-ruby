# frozen_string_literal: true

# ============================================================================
# Project:   ShinyInserts plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyInserts/app/helpers/shiny_inserts/main_site_helper.rb
# Purpose:   Insert helpers for main site
#
# Copyright 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyInserts
  # Helpers for Inserts - part of ShinyInserts plugin for ShinyCMS
  module MainSiteHelper
    def insert( name )
      ShinyInserts::Set.first.elements.where( name: name ).pick( :content )
    end

    def insert_type?( name, type )
      ShinyInserts::Set.first.elements.where( name: name ).pick( :element_type ) == type
    end
  end
end
