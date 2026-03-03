# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
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
        all_routes.any? { |route| route.path.spec.to_s.start_with? "/#{slug}/" }
      end

      def all_routes
        (
          [ Rails.application.routes.routes.routes ] +
          [ ShinyCMS::Engine.routes.routes.routes ] +
          [ ShinyCMS.plugins.routes  ]
        ).flatten
      end
    end
  end
end
