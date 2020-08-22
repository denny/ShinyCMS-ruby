# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Record details of a user's consent (e.g. to be on one of your mailing lists)
class Consent < ApplicationRecord
  validates :purpose, presence: true

  belongs_to :purpose, inverse_of: :consent, polymorphic: true
end
