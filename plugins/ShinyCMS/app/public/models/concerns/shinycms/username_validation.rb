# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Regex for validating usernames
  module UsernameValidation
    # Allowed characters for usernames: a-z A-Z 0-9 . _ -
    REGEX = %r{[a-zA-Z0-9][-_.a-zA-Z0-9]*}
    public_constant :REGEX

    ANCHORED_REGEX = %r{\A#{REGEX}\z}
    public_constant :ANCHORED_REGEX
  end
end
