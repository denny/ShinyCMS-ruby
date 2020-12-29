# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Model for tracking emails using ahoy
class Ahoy::Message < ApplicationRecord
  self.table_name = 'ahoy_messages'

  belongs_to :user, polymorphic: true, optional: true
end
