# frozen_string_literal: true

# ShinyInserts plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyInserts
  # Helpers for Inserts - part of ShinyInserts plugin for ShinyCMS
  module MainSiteHelper
    def insert( name )
      return unless name.is_a? Symbol

      ShinyInserts::Set.first.elements.where( name: name.to_s ).pick( :content )
    end

    def insert_type?( name, type )
      return false unless name.is_a? Symbol
      return false unless type.is_a? Symbol

      ShinyInserts::Set.first.elements.where( name: name.to_s ).pick( :element_type ) == type.to_s
    end

    def inserts_exist?
      ShinyInserts::Set.first.elements.present?
    end
  end
end
