# frozen_string_literal: true

module ShinyForms
  # Base helpers for ShinyCMS forms plugin
  module ApplicationHelper
    def admin_index_path
      ShinyForms::Engine.routes.url_helpers.public_send( 'forms_path' )
    end
  end
end
