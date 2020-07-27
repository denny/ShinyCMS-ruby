# frozen_string_literal: true

# Autogenerate content titles from content names (if not explicitly set)
module ShinyTitle
  extend ActiveSupport::Concern

  included do
    validates :name,  presence: true
    validates :title, presence: true

    before_validation :generate_title, if: -> { title.blank? && name.present? }

    def generate_title
      self.title = name.titlecase
    end
  end
end
