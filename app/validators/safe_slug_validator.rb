# frozen_string_literal: true

# Validator for top-level slugs (pages and page sections) to make sure they
# don't collide with controller namespaces
class SafeSlugValidator < ActiveModel::Validator
  def validate( record )
    return if record.section.present?

    record.errors.add( :slug, :slug_taken ) if unsafe?( record.slug )
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
