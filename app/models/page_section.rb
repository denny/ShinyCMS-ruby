# Model class for page sections
class PageSection < ApplicationRecord
  # Class methods
  def self.top_level_sections
    PageSection.where( section_id: nil )
  end
end
