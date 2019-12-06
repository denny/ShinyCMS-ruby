# Model for feature flags
class FeatureFlag < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
