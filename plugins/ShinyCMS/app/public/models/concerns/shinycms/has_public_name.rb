# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Provides .name method for anything with public_name and internal_name attributes
  module HasPublicName
    extend ActiveSupport::Concern

    included do
      validates :internal_name, presence: true

      def name
        public_name.presence || internal_name
      end

      alias_method :slug_base, :name
    end
  end
end
