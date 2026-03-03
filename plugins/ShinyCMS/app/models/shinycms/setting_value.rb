# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Model class for setting values (site-wide and per-user config settings)
  class SettingValue < ApplicationRecord
    include ShinyCMS::SoftDelete

    # Associations

    belongs_to :setting, inverse_of: :values
    belongs_to :user,    inverse_of: :settings, optional: true

    # Validations

    validates :setting_id, presence: true
    validates :user_id,    uniqueness: {
      scope:   :setting,
      message: I18n.t( 'shinycms.models.setting_value.one_per_user' )
    }
  end
end
