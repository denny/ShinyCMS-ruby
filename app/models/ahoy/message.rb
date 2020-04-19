# Model for tracking emails using ahoy
class Ahoy::Message < ApplicationRecord
  self.table_name = 'ahoy_messages'

  belongs_to :user, polymorphic: true, optional: true

  # Configure default count-per-page for pagination
  paginates_per 20
end
