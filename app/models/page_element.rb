# frozen_string_literal: true

# Model class for page elements
class PageElement < ApplicationRecord
  include ShinyElement

  belongs_to :page, inverse_of: :elements

  validates :page, presence: true

  # Class methods

  def self.dump_for_demo?
    true
  end
end
