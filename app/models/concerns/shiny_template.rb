# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Common behaviour for content templates - e.g. ShinyPages::Template, ShinyNewsletters::Template
module ShinyTemplate
  extend ActiveSupport::Concern

  included do
    # Associations

    has_many  :elements, -> { order( position: :asc ) },
              inverse_of: :template,
              foreign_key: :template_id,
              class_name: 'TemplateElement',
              dependent: :destroy

    accepts_nested_attributes_for :elements

    # Validations

    validates :filename, presence: true
    validates :name,     presence: true

    # Plugins

    paginates_per 20

    # Before/after actions

    after_create :add_elements

    # Instance methods

    def file_exists?
      self.class.available_templates.include? filename
    end

    # Specify policy class for Pundit
    def policy_class
      self.class.policy_class
    end

    private

    def add_default_element( name )
      elements.create( name: name )
    end

    def add_image_element( name )
      elements.create(
        name: name,
        element_type: I18n.t( 'admin.elements.image' )
      )
    end

    def add_html_element( name )
      elements.create(
        name: name,
        element_type: I18n.t( 'admin.elements.html' )
      )
    end

    def add_long_text_element( name )
      elements.create(
        name: name,
        element_type: I18n.t( 'admin.elements.long_text' )
      )
    end
  end
end
