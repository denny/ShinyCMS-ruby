# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Links users and capabilities
class UserCapability < ApplicationRecord
  belongs_to :user
  belongs_to :capability

  acts_as_paranoid
  validates_as_paranoid
end
