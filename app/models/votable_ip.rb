# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Track IP address of anonymous votable voters ('likes' feature)
class VotableIP < ApplicationRecord
  acts_as_voter
end
