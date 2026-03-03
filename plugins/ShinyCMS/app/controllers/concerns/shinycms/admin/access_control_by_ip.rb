# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Restrict admin area access to a short-list of allowed IP addresses
    module AccessControlByIP
      extend ActiveSupport::Concern

      included do
        before_action :enforce_allowed_ips

        def enforce_allowed_ips
          allowed_ips = Setting.get :allowed_ips
          return if allowed_ips.blank?

          allowed_ips_list = valid_ish( split_into_list( remove_comments( allowed_ips.downcase ) ) )

          return if allowed_ips_list.include? request.remote_ip

          redirect_to main_app.root_path
        end

        private

        def remove_comments( text_with_comments_in_brackets )
          text_with_comments_in_brackets.gsub %r{\([^)]*\)}, ''
        end

        def split_into_list( list_of_ips_in_a_string )
          # IP addresses should only contain hex numbers and . : and possibly /
          # ... so let's regard anything not on that list as a valid separator :D
          list_of_ips_in_a_string.split %r{[^0-9a-fA-F.:/]+}
        end

        def valid_ish( list_of_ips )
          ipv4_ish_or_ipv6_ish = %r{[0-9a-f]+\.[0-9a-f]+\.[0-9a-f]+\.[0-9a-f]+|[0-9a-f]+:[0-9a-f]+}

          list_of_ips.select { |ip| ip.length > 6 && ip.length < 46 }
                     .select { |ip| ip.match? ipv4_ish_or_ipv6_ish  }
        end
      end
    end
  end
end
