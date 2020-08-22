# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Validator for top-level slugs (possible with pages and page sections)
# to make sure they don't collide with controller namespaces
class SafeTopLevelSlugValidator < ActiveModel::Validator
  def validate( record )
    return if record.section.present?

    record.errors.add( :slug, :slug_not_safe_at_top_level ) if unsafe?( record.slug )
  end

  private

  def unsafe?( slug )
    Rails.application.routes.routes.any? do |route|
      route.path.spec.to_s.match( %r{\A/(?<part>[^/]+)/} ) do |m|
        slug == m[ :part ]
      end
    end
  end
end
