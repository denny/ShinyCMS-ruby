# Model for tracking website events using ahoy
class Ahoy::Event < ApplicationRecord
  include Ahoy::QueryMethods

  self.table_name = 'ahoy_events'

  belongs_to :visit
  belongs_to :user, optional: true
end
