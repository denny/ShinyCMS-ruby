# frozen_string_literal: true

module ShinyForms
  # Basic form handlers for ShinyCMS
  class FormHandler
    FORM_HANDLERS = %w[ plain_email template_email ].freeze
    public_constant :FORM_HANDLERS

    def plain_email( form, form_data )
      FormMailer.plain( form.email_to, form.internal_name, form_data ).deliver_now
    end

    def template_email( form, form_data )
      FormMailer.with_template( form.email_to, form.internal_name, form_data, form.filename ).deliver_now
    end
  end
end
