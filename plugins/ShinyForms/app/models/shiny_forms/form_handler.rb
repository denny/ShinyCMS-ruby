# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Basic form handlers, provided by ShinyForms plugin for ShinyCMS
  class FormHandler
    FORM_HANDLERS = %w[ store_in_database plain_email template_email ].freeze
    public_constant :FORM_HANDLERS

    def store_in_database( form, form_data )
      # TODO: Add shiny_forms_submissions table, save form submissions in it, create admin page for reading it
    end

    def plain_email( form, form_data )
      FormMailer.plain( form.email_to, form.internal_name, form_data ).deliver_later
    end

    def template_email( form, form_data )
      FormMailer.with_template( form.email_to, form.internal_name, form_data, form.filename ).deliver_later
    end
  end
end
