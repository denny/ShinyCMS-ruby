# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  module TopLevelSlugValidator
    # Validator to check that top-level page/section slugs don't collide with controller namespaces
    class UniqueTopLevelSlugValidator < ActiveModel::Validator
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
  end
end
