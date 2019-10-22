# Validator for top-level slugs (pages and page sections) to make sure they
# don't collide with controller namespaces
class SafeSlugValidator < ActiveModel::Validator
  def validate( record )
    return unless record.section.nil?

    Rails.application.routes.routes.each do |route|
      route.path.spec.to_s.match( %r{\A/(?<part>[^/]+)/} ) do |m|
        if record.slug == m[ :part ]
          record.errors.add( :slug, 'cannot be used as a top-level slug' )
        end
      end
    end
  end
end
