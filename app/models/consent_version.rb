# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Model to store the full text that users of the site may be asked to agree to, for GDPR compliance
class ConsentVersion < ApplicationRecord
  include ShinyDemoDataProvider
  include ShinySlug

  validates :name,      presence: true
  validates :full_text, presence: true
end
