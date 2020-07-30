# frozen_string_literal: true

# Model class for page elements
class PageElement < ApplicationRecord
  include ShinyElement

  belongs_to :page, inverse_of: :elements

  validates :page, presence: true
end
