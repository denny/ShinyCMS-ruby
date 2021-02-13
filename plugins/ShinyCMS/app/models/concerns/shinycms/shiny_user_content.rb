# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Associations and plugin methods to hook into main app features and content
# TODO: This should be phased out as these features are moved into plugins
module ShinyUserContent
  extend ActiveSupport::Concern

  included do
    # Upvotes AKA 'likes' - powered by Acts As Votable
    acts_as_voter

    # Email open/click stats - powered by Ahoy::Email
    has_many :messages, dependent: :nullify, class_name: 'Ahoy::Message'
    # Web traffic stats - powered by Ahoy
    has_many :visits,   dependent: :nullify, class_name: 'Ahoy::Visit'

    has_many :comments, as: :author, dependent: :destroy
    has_many :settings, inverse_of: :user, dependent: :destroy, class_name: 'SettingValue'
  end
end
