# frozen_string_literal: true

# Model for tracking website visits using ahoy
class Ahoy::Visit < ApplicationRecord
  include ShinyPaging

  self.table_name = 'ahoy_visits'

  has_many :events, dependent: :destroy, class_name: 'Ahoy::Event'
  belongs_to :user, optional: true
end
