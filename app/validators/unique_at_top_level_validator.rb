# frozen_string_literal: true

# Validator for top-level slugs (possible with pages and page sections)
# to make sure they don't collide with controller namespaces
class UniqueAtTopLevelValidator < ActiveModel::Validator
  def validate( record )
    return if record.section.present?

    record.errors.add( :slug, :top_level_slug ) if unsafe?( record.slug )
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
