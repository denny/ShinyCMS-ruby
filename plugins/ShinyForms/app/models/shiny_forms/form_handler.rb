# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Basic form handlers, provided by ShinyForms plugin for ShinyCMS
  class FormHandler
    FORM_HANDLERS = %w[ store_in_database send_plain_email send_html_email ].freeze
    public_constant :FORM_HANDLERS

    def store_in_database( form, form_data )
      # TODO: Add shiny_forms_submissions table, save form submissions in it, create admin page for reading it
    end

    def send_plain_email( form, form_data )
      FormMailer.with( to: form.email_to, form_name: form.internal_name, form_data: form_data )
                .plain_email.deliver_later
    end

    def send_html_email( form, form_data )
      FormMailer.with( to: form.email_to, form_name: form.internal_name, form_data: form_data )
                .html_email( template_file: form.filename ).deliver_later
    end
  end
end
