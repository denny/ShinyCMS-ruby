# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Methods to facilitate easy translation of model class names into human-readable versions
  module ShinyClassName
    extend ActiveSupport::Concern

    class_methods do
      def translated_name
        I18n.t( "shinycms.models.names.#{i18n_label}" )
      end

      def i18n_label
        name.underscore.tr( '/', '_' )
      end
    end
  end
end
