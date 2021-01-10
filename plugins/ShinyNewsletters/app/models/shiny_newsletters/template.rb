# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Model for newsletter templates
  class Template < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyMJMLTemplate
    include ShinySoftDelete

    # Associations

    has_many :editions, inverse_of: :template, dependent: :restrict_with_error

    # Class methods

    def self.template_dir
      Theme.current.template_dir( 'shiny_newsletters/newsletter_mailer' ) if Theme.current.present?
    end

    # Add another validation at the end, because it uses methods included/defined above
    validates :filename, inclusion: {
      in:      available_templates,
      message: I18n.t( 'models.shiny_newsletters.template.template_file_must_exist' )
    }
  end
end
