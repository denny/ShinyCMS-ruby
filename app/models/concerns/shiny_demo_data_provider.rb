# frozen_string_literal: true

# Volunteers for data dumping duty!
module ShinyDemoDataProvider
  extend ActiveSupport::Concern

  included do
    def self.dump_for_demo?
      true
    end
  end
end
