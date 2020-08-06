# frozen_string_literal: true

module ShinyForms
  # Basic form handlers for ShinyCMS
  class FormHandler
    FORM_HANDLERS = %w[ plain_email template_email ].freeze
    public_constant :FORM_HANDLERS

    def plain_email( email_to, form_name, form_data, _ )
      FormMailer.plain( email_to, form_name, form_data ).deliver_now
    end

    def template_email( email_to, form_name, form_data, filename )
      FormMailer.with_template( email_to, form_name, form_data, filename ).deliver_now
    end
  end
end
