# frozen_string_literal: true

module ShinyPages
  # Model class for page elements
  class PageElement < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyElement

    belongs_to :page, inverse_of: :elements

    validates :page, presence: true
  end
end
