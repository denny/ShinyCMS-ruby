# frozen_string_literal: true

# Common behaviour for models that have a uuid token attribute
module ShinyToken
  extend ActiveSupport::Concern

  included do
    validates :token, presence: true, uniqueness: true

    before_validation :generate_token, if: -> { token.blank? }

    def generate_token
      self.token = SecureRandom.uuid
    end
  end
end
