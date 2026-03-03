# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Methods to turn model class names into human-readable names - e.g. 'blog post'
  # Uses the locale string if there is one, otherwise makes best effort
  module HasReadableName
    extend ActiveSupport::Concern

    class_methods do
      def readable_name
        if I18n.exists? "shinycms.models.names.#{i18n_label}"
          I18n.t "shinycms.models.names.#{i18n_label}"
        else
          name.demodulize.humanize.downcase
        end
      end

      def i18n_label
        name.underscore.tr( '/', '_' )
      end
    end
  end
end
