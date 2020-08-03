# frozen_string_literal: true

module ShinyForms
  # Model for ShinyCMS forms
  class Form < ApplicationRecord
    include ShinyName
    include ShinySlug

    # Instance methods

    def handlers
      @handlers ||= FormHandler.new
    end

    def send_to_handler( form_data )
      if handlers.respond_to?( handler )
        handlers.public_send( handler.to_sym, form_data )
      else
        Rails.logger.warn "Unknown form handler '#{handler}' (form ID: #{id})"
      end
    end

    # Specify policy class for Pundit
    def policy_class
      ::Admin::FormPolicy
    end

    # Class methods

    def self.policy_class
      ::Admin::FormPolicy
    end
  end
end
