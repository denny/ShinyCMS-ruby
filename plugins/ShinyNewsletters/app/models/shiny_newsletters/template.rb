# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Model for newsletter templates - part of the ShinyNewsletters plugin for ShinyCMS
  class Template < ApplicationRecord
    include ShinyCMS::MJMLTemplate

    include ShinyCMS::HasReadableName
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    # Associations

    has_many :editions, inverse_of: :template, dependent: :restrict_with_error

    # Class methods

    def self.template_dir
      ShinyCMS::Theme.template_dir 'shiny_newsletters/newsletter_mailer'
    end

    def self.admin_search( search_term )
      where( 'name ilike ?', "%#{search_term}%" )
        .or( where( 'description ilike ?', "%#{search_term}%" ) )
        .order( :name )
    end

    # Add another validation at the end, because it uses methods included/defined above
    validates :filename, inclusion: {
      in:      ->( _ ) { available_templates },
      message: I18n.t( 'models.shiny_newsletters.template.template_file_must_exist' )
    }
  end
end
