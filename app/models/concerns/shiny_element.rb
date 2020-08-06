# frozen_string_literal: true

# Common behaviour that all element models might want to use/offer
# (PageElement, FormElement, InsertElement, etc)
module ShinyElement
  extend ActiveSupport::Concern

  # Allowed characters for element names: a-z A-Z 0-9 _
  ELEMENT_NAME_REGEX = %r{[_a-zA-Z0-9]+}.freeze
  private_constant :ELEMENT_NAME_REGEX
  ANCHORED_ELEMENT_NAME_REGEX = %r{\A#{ELEMENT_NAME_REGEX}\z}.freeze
  private_constant :ANCHORED_ELEMENT_NAME_REGEX

  included do
    validates :name, presence: true
    validates :name, format:   ANCHORED_ELEMENT_NAME_REGEX

    before_validation :format_name, if: -> { name.present? }

    def format_name
      self.name = name.parameterize.underscore
    end
  end
end
