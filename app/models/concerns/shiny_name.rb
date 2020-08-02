# frozen_string_literal: true

# Provides .name method for anything with public_name and internal_name attributes
module ShinyName
  extend ActiveSupport::Concern

  included do
    validates :internal_name, presence: true

    def name
      public_name || internal_name
    end
  end
end
