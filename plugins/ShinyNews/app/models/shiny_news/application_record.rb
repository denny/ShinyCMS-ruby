# frozen_string_literal: true

module ShinyNews
  # ShinyNews base model
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def url_helpers
      ShinyNews::Engine.routes.url_helpers
    end

    def human_name
      name = self.class.name.underscore.gsub( '/', '_' ).gsub( 'shiny_', '' )
      return name.humanize.downcase unless I18n.exists?( "element_types.#{name}" )

      I18n.t( "element_types.#{name}" )
    end

    def self.dump_for_demo?
      false
    end
  end
end
