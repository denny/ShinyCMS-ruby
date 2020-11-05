# frozen_string_literal: true

# Model for tracking emails using ahoy
class Ahoy::Message < ApplicationRecord
  include ShinyPaging

  self.table_name = 'ahoy_messages'

  belongs_to :user, polymorphic: true, optional: true
end
