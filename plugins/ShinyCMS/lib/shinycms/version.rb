# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# ShinyCMS version number ('Ubuntu style', YY.MM)
module ShinyCMS
  VERSION = '21.05'
  public_constant :VERSION

  # Use the start of the git commit SHA as a release identifier
  # RELEASE = `git show --abbrev=4 --pretty=%h -q`.chomp
  # public_constant :RELEASE
end
