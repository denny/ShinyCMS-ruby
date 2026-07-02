# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Model for shop templates - part of the ShinyShop plugin for ShinyCMS
  class Template < ApplicationRecord
    include ShinyCMS::HTMLTemplate

    include ShinyCMS::HasReadableName
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    # Associations

    has_many :products, inverse_of: :template, dependent: :restrict_with_error

    # Class methods

    def self.template_dir
      ShinyCMS::Theme.template_dir 'shiny_shop/products'
    end

    def self.admin_search( search_term )
      where( 'name ilike ?', "%#{search_term}%" )
        .or( where( 'description ilike ?', "%#{search_term}%" ) )
        .order( :name )
    end

    # Add another validation at the end, because it uses methods included/defined above
    validates :filename, inclusion: {
      in:      ->( _ ) { available_templates },
      message: I18n.t( 'models.shiny_shop.template.template_file_must_exist' )
    }
  end
end
