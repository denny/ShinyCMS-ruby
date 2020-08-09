# frozen_string_literal: true

module ShinyForms
  # ShinyForms base model
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def url_helpers
      ShinyForms::Engine.routes.url_helpers
    end

    def human_name
      self.class.name.underscore.gsub( '/', '_' ).gsub( 'shiny_', '' ).humanize.downcase
    end
  end
end
