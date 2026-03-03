# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for models that have a uuid token attribute
  module HasToken
    extend ActiveSupport::Concern

    included do
      validates :token, presence: true, uniqueness: true

      before_validation :generate_token, if: -> { token.blank? }

      def generate_token
        self.token = SecureRandom.uuid
      end
    end
  end
end
