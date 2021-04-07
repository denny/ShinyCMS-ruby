# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Interface
    # Make EmailRecipient.has_many available to models in other plugins
    class EmailRecipient
      def self.has_many( *args, **kwargs )
        ShinyCMS::EmailRecipient.has_many( *args, **kwargs )
      end

      def self.instance?( instance )
        instance.is_a? ShinyCMS::EmailRecipient
      end
    end
  end
end
