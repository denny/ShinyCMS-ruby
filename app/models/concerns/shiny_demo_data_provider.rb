# frozen_string_literal: true

# Provides .name method for anything with public_name and internal_name attributes
module ShinyDemoDataProvider
  extend ActiveSupport::Concern

  included do
    def self.dump_for_demo?
      true
    end
  end
end
