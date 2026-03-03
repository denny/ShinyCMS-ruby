# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for non-Devise, non-admin, password-related features
  module PasswordReportAction
    extend ActiveSupport::Concern

    included do
      def password_report
        render json: Zxcvbn.test( params[ :password ] )
      end
    end
  end
end
